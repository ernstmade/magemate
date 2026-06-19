import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/parser/card_text_parser.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/deck_providers.dart';
import '../../shared/models/trigger_style.dart';
import '../../shared/models/trigger_type.dart';

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
        extraConditions: e.extraConditions,
        damageAmount: e.damageAmount,
        damageTarget: e.damageTarget,
        damageMultiplier: e.damageMultiplier,
        damageMinimum: e.damageMinimum,
        replacementScope: e.replacementScope,
        dynamicDamage: e.dynamicDamage,
      );
      // Normalisiertes Muster als gelernte Regel speichern
      await repo.upsertLearnedRule(
        pattern: CardTextParser.normalize(e.description, selfName: item.definition.name),
        trigger: e.trigger.name,
        triggerDetail: e.triggerDetail,
        extraConditions: e.extraConditions.isEmpty ? null : e.extraConditions.map((c) => c.name).join(','),
        shortLabelTemplate: CardTextParser.makeTemplate(e.shortLabel, e.damageAmount),
        shortLabelEnTemplate: CardTextParser.makeTemplate(e.shortLabelEn, e.damageAmount),
        hasDamageAmount: e.damageAmount != null,
        damageTarget: e.damageTarget?.name,
        damageMultiplier: e.damageMultiplier,
        damageMinimum: e.damageMinimum,
        replacementScope: e.replacementScope?.name,
        dynamicDamage: e.dynamicDamage,
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
    final detail = _detailLabel(e, isDe);

    return CheckboxListTile(
      value: item.selected,
      onChanged: (v) => onToggle(v ?? false),
      secondary: Icon(style.icon, color: style.color, size: 20),
      title: Text(
        detail != null ? '$triggerLabel — $detail' : triggerLabel,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        e.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      dense: true,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }


  String? _detailLabel(ParsedEffect e, bool isDe) {
    final parts = <String>[];
    if (e.damageAmount != null) {
      final prefix = e.trigger == TriggerType.staticDamageModifier ? '+' : '';
      parts.add('$prefix${e.damageAmount}');
    }
    if (e.damageMultiplier != null) parts.add('×${e.damageMultiplier}');
    if (e.damageTarget != null) {
      parts.add(isDe ? _targetLabelDe(e.damageTarget!) : _targetLabelEn(e.damageTarget!));
    }
    if (parts.isEmpty) return null;
    return parts.join(' ');
  }

  String _targetLabelDe(DamageTarget t) => switch (t) {
    DamageTarget.eachOpponent => 'an jeden Gegner',
    DamageTarget.singleOpponent => 'an Gegner',
    DamageTarget.singleCreature => 'an Kreatur',
    DamageTarget.eachCreature => 'an jede Kreatur',
    DamageTarget.eachOpponentCreatures => 'an Kreaturen',
  };

  String _targetLabelEn(DamageTarget t) => switch (t) {
    DamageTarget.eachOpponent => 'to each opponent',
    DamageTarget.singleOpponent => 'to opponent',
    DamageTarget.singleCreature => 'to creature',
    DamageTarget.eachCreature => 'to each creature',
    DamageTarget.eachOpponentCreatures => 'to creatures',
  };
}
