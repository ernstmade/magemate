import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/parser/card_text_parser.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/deck_providers.dart';
import '../../shared/models/trigger_style.dart';
import '../../shared/models/trigger_type.dart';
import 'play_screen.dart' show LocaleToggleButton;

class _Item {
  _Item({required this.definition, required this.effect});


  final CardDefinition definition;
  final ParsedEffect effect;
  bool selected = true;
}

class EffectSuggestionScreen extends ConsumerStatefulWidget {
  const EffectSuggestionScreen({super.key, required this.suggestions});

  final List<(CardDefinition, ParsedEffect)> suggestions;

  @override
  ConsumerState<EffectSuggestionScreen> createState() => _EffectSuggestionScreenState();
}

class _EffectSuggestionScreenState extends ConsumerState<EffectSuggestionScreen> {
  late final List<_Item> _items;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _items = [for (final (def, effect) in widget.suggestions) _Item(definition: def, effect: effect)];
  }

  int get _selectedCount => _items.where((i) => i.selected).length;

  Future<void> _save() async {
    setState(() => _saving = true);
    final repo = ref.read(deckRepositoryProvider);
    for (final item in _items.where((i) => i.selected)) {
      final e = item.effect;
      await repo.addEffect(
        item.definition.id,
        e.trigger,
        e.shortLabel,
        e.shortLabelEn,
        e.description,
        triggerDetail: e.triggerDetail,
        triggerConditionText: e.triggerConditionText,
        extraConditions: e.extraConditions,
        damageAmount: e.damageAmount,
        damageTarget: e.damageTarget,
        damageMultiplier: e.damageMultiplier,
        damageMinimum: e.damageMinimum,
        replacementScope: e.replacementScope,
        dynamicDamage: e.dynamicDamage,
        effectDetail: e.effectDetail,
        effectExtraConditions: e.effectExtraConditions,
      );
      // Normalisiertes Muster als gelernte Regel speichern
      await repo.upsertLearnedRule(
        pattern: CardTextParser.normalize(e.description, selfName: item.definition.name),
        trigger: e.trigger.name,
        triggerDetail: e.triggerDetail,
        triggerConditionText: e.triggerConditionText,
        extraConditions: e.extraConditions.isEmpty ? null : e.extraConditions.map((c) => c.name).join(','),
        shortLabelTemplate: CardTextParser.makeTemplate(e.shortLabel, e.damageAmount),
        shortLabelEnTemplate: CardTextParser.makeTemplate(e.shortLabelEn, e.damageAmount),
        hasDamageAmount: e.damageAmount != null,
        damageTarget: e.damageTarget?.name,
        damageMultiplier: e.damageMultiplier,
        damageMinimum: e.damageMinimum,
        replacementScope: e.replacementScope?.name,
        dynamicDamage: e.dynamicDamage,
        effectDetail: e.effectDetail,
        effectExtraConditions: e.effectExtraConditions.isEmpty ? null : e.effectExtraConditions.map((c) => c.name).join(','),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final isDe = Localizations.localeOf(context).languageCode == 'de';

    // Group items by card definition id
    final Map<int, List<_Item>> byCard = {};
    for (final item in _items) {
      byCard.putIfAbsent(item.definition.id, () => []).add(item);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.effectSuggestionTitle),
        actions: [
          const LocaleToggleButton(),
          TextButton(
            onPressed: () {
              setState(() {
                final allSelected = _selectedCount == _items.length;
                for (final i in _items) {
                  i.selected = !allSelected;
                }
              });
            },
            child: Text(_selectedCount == _items.length ? l10n.effectSuggestionDeselectAll : l10n.effectSuggestionSelectAll),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(l10n.effectSuggestionHint, style: Theme.of(context).textTheme.bodySmall),
                ),
                for (final entry in byCard.entries) ...[
                  _CardHeader(
                    definition: entry.value.first.definition,
                    isDe: isDe,
                  ),
                  for (final item in entry.value)
                    _SuggestionTile(
                      item: item,
                      isDe: isDe,
                      onToggle: (v) => setState(() => item.selected = v),
                    ),
                ],
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving || _selectedCount == 0 ? null : _save,
                  child: _saving
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l10n.effectSuggestionSave(_selectedCount)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.definition, required this.isDe});

  final CardDefinition definition;
  final bool isDe;

  @override
  Widget build(BuildContext context) {
    final name = isDe ? (definition.printedName ?? definition.name) : definition.name;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(name, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({required this.item, required this.isDe, required this.onToggle});

  final _Item item;
  final bool isDe;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final e = item.effect;
    final style = triggerStyle(e.trigger);
    final triggerLabel = triggerTypeLabel(e.trigger, isDe: isDe);

    final shortLabel = isDe
        ? e.shortLabel
        : (e.shortLabelEn.isNotEmpty ? e.shortLabelEn : e.shortLabel);

    // shortLabel hat Vorrang (Parser liefert jetzt kompakte Labels).
    // Fallback: extrahierter Oracle-Text-Teil nach dem Trigger-Komma, dann voller Text.
    final effectText = shortLabel.isNotEmpty
        ? shortLabel
        : (_extractEffectClause(e.description) ?? e.description);

    // Trigger-Detail (z.B. "Instant / Sorcery", "Rote Quelle")
    final triggerDetailText = triggerDetailLabel(e.triggerDetail, isDe: isDe);

    // Trigger-Conditions (TriggerCondition-Enum)
    final triggerConditions = e.extraConditions
        .map((c) => switch (c) {
              TriggerCondition.singleTarget        => isDe ? 'Einzelziel'          : 'Single target',
              TriggerCondition.singleCreatureTarget => isDe ? 'Einzelnes Kreatur-Ziel' : 'Single creature target',
              TriggerCondition.damageToOpponent    => isDe ? 'Schaden an Gegner'   : 'Damage to opponent',
            })
        .join(' · ');

    // Effekt-Einschränkungen (EffectCondition-Enum + effectDetail)
    final effectRestriction = [
      for (final c in e.effectExtraConditions) effectConditionLabel(c, isDe: isDe),
      if (e.effectDetail != null) e.effectDetail!,
    ].join(' · ');

    final labelColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45);
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(color: labelColor);
    final rowLabel = isDe ? 'Auslöser' : 'Trigger';
    final effLabel = isDe ? 'Effekt' : 'Effect';
    final textLabel = isDe ? 'Text' : 'Text';

    return InkWell(
      onTap: () => onToggle(!item.selected),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(style.icon, color: style.color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LabeledRow(label: rowLabel, labelStyle: labelStyle,
                      child: Text(triggerLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: style.color))),
                  if (triggerDetailText != null) ...[
                    const SizedBox(height: 4),
                    _LabeledRow(
                      label: isDe ? 'Auslöser-Detail' : 'Trigger detail',
                      labelStyle: labelStyle,
                      child: Text(triggerDetailText, style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ],
                  if (triggerConditions.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _LabeledRow(
                      label: isDe ? 'Auslöser-Bedingung' : 'Trigger condition',
                      labelStyle: labelStyle,
                      child: Text(triggerConditions, style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ],
                  if (e.triggerConditionText != null) ...[
                    const SizedBox(height: 4),
                    _LabeledRow(
                      label: isDe ? 'Bedingung' : 'Condition',
                      labelStyle: labelStyle,
                      child: Text(e.triggerConditionText!, style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ],
                  const SizedBox(height: 4),
                  _LabeledRow(label: effLabel, labelStyle: labelStyle,
                      child: Text(effectText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
                  if (effectRestriction.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _LabeledRow(
                      label: isDe ? 'Effekt-Einschränkung' : 'Effect restriction',
                      labelStyle: labelStyle,
                      child: Text(effectRestriction, style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ],
                  const SizedBox(height: 4),
                  _LabeledRow(label: textLabel, labelStyle: labelStyle,
                      child: Text(e.description, style: Theme.of(context).textTheme.bodySmall)),
                ],
              ),
            ),
            Checkbox(
              value: item.selected,
              onChanged: (v) => onToggle(v ?? false),
            ),
          ],
        ),
      ),
    );
  }


  /// Extrahiert den Effekt-Teil aus einem Oracle-Text-Trigger-Satz.
  /// "Whenever X, EFFECT." → "EFFECT."
  String? _extractEffectClause(String oracleText) {
    final match = RegExp(
      r'^(?:whenever|when|at the beginning of|at the end of|at the start of)[^,]+,\s*(.+)',
      caseSensitive: false,
      dotAll: true,
    ).firstMatch(oracleText.trim());
    return match?.group(1)?.trim();
  }

}

class _LabeledRow extends StatelessWidget {
  const _LabeledRow({required this.label, required this.labelStyle, required this.child});

  final String label;
  final TextStyle? labelStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 64,
          child: Text('$label:', style: labelStyle),
        ),
        Expanded(child: child),
      ],
    );
  }
}
