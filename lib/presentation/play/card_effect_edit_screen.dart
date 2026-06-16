import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/deck_providers.dart';
import '../../shared/models/trigger_type.dart';
import 'effect_tile.dart';

/// Vollbild-Screen zum Anlegen und Löschen von Effekten einer Karte.
/// Wird aus dem Karten-Info-Sheet über den Edit-Button geöffnet.
class CardEffectEditScreen extends ConsumerStatefulWidget {
  const CardEffectEditScreen({super.key, required this.definition});

  final CardDefinition definition;

  @override
  ConsumerState<CardEffectEditScreen> createState() =>
      _CardEffectEditScreenState();
}

class _CardEffectEditScreenState extends ConsumerState<CardEffectEditScreen> {
  TriggerType _selectedTrigger = TriggerType.values.first;
  SpellCategory? _selectedSpellCategory;
  SourceFilter? _selectedSourceFilter;
  bool _singleTarget = false;
  DamageTarget? _selectedDamageTarget;
  ReplacementScope? _selectedReplacementScope;
  bool _dynamicDamage = false;
  final _shortLabelController = TextEditingController();
  final _shortLabelEnController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _damageAmountController = TextEditingController();
  final _damageMultiplierController = TextEditingController();
  final _damageMinimumController = TextEditingController();

  CardDefinition get definition => widget.definition;

  @override
  void dispose() {
    _shortLabelController.dispose();
    _shortLabelEnController.dispose();
    _descriptionController.dispose();
    _damageAmountController.dispose();
    _damageMultiplierController.dispose();
    _damageMinimumController.dispose();
    super.dispose();
  }

  Future<void> _addEffect() async {
    final description = _descriptionController.text.trim();
    final shortLabel = _shortLabelController.text.trim();
    final shortLabelEn = _shortLabelEnController.text.trim();
    if (description.isEmpty) return;
    final detailKind = triggerDetailKind(_selectedTrigger);
    if (detailKind == TriggerDetailKind.spellCategory &&
        _selectedSpellCategory == null) {
      return;
    }
    if (detailKind == TriggerDetailKind.sourceFilter &&
        _selectedSourceFilter == null) {
      return;
    }

    String? triggerDetail;
    switch (detailKind) {
      case TriggerDetailKind.spellCategory:
        triggerDetail = _selectedSpellCategory?.name;
      case TriggerDetailKind.sourceFilter:
        triggerDetail = _selectedSourceFilter?.name;
      case TriggerDetailKind.none:
        triggerDetail = null;
    }
    final damageAmount = int.tryParse(_damageAmountController.text.trim());
    final damageMultiplier = int.tryParse(
      _damageMultiplierController.text.trim(),
    );
    final damageMinimum = int.tryParse(_damageMinimumController.text.trim());

    await ref.read(deckRepositoryProvider).addEffect(
      definition.id,
      _selectedTrigger,
      shortLabel,
      shortLabelEn,
      description,
      triggerDetail: triggerDetail,
      extraConditions: _singleTarget ? {EffectCondition.singleTarget} : {},
      damageAmount: damageAmount,
      damageTarget: damageAmount != null ? _selectedDamageTarget : null,
      damageMultiplier: damageMultiplier,
      damageMinimum: damageMinimum,
      replacementScope: _selectedReplacementScope,
      dynamicDamage: _dynamicDamage,
    );

    _shortLabelController.clear();
    _shortLabelEnController.clear();
    _descriptionController.clear();
    _damageAmountController.clear();
    _damageMultiplierController.clear();
    _damageMinimumController.clear();
    setState(() {
      _selectedSpellCategory = null;
      _selectedSourceFilter = null;
      _singleTarget = false;
      _selectedDamageTarget = null;
      _selectedReplacementScope = null;
      _dynamicDamage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final effects = ref.watch(effectsForCardDefinitionProvider(definition.id));

    return Scaffold(
      appBar: AppBar(title: Text(definition.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Bestehende Effekte ────────────────────────────────────────
            Text(
              l10n.cardInfoEffectsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            effects.when(
              data: (effects) {
                if (effects.isEmpty) return Text(l10n.cardInfoNoEffects);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final effect in effects)
                      EffectTile(
                        effect: effect,
                        definition: definition,
                        cardName: effect.trigger,
                        subtitleFirst: true,
                        contentPadding: EdgeInsets.zero,
                        onDelete: () => ref
                            .read(deckRepositoryProvider)
                            .deleteEffect(effect.id),
                      ),
                  ],
                );
              },
              error: (e, _) => Text('Error: $e'),
              loading: () => const SizedBox(
                height: 24,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

            const Divider(height: 32),

            // ── Neuen Effekt hinzufügen ───────────────────────────────────
            Text(
              l10n.cardInfoAddEffect,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            // Trigger
            DropdownButtonFormField<TriggerType>(
              initialValue: _selectedTrigger,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.cardInfoTriggerLabel),
              items: [
                for (final trigger in TriggerType.values)
                  DropdownMenuItem(
                    value: trigger,
                    child: Text(trigger.name),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTrigger = value;
                    _selectedSpellCategory = null;
                    _selectedSourceFilter = null;
                  });
                }
              },
            ),

            // Trigger-Detail: SpellCategory
            if (triggerDetailKind(_selectedTrigger) ==
                TriggerDetailKind.spellCategory) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<SpellCategory>(
                initialValue: _selectedSpellCategory,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: l10n.cardInfoTriggerDetailLabel,
                ),
                items: [
                  for (final category in SpellCategory.values)
                    DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    ),
                ],
                onChanged: (value) =>
                    setState(() => _selectedSpellCategory = value),
              ),
            ],

            // Trigger-Detail: SourceFilter
            if (triggerDetailKind(_selectedTrigger) ==
                TriggerDetailKind.sourceFilter) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<SourceFilter>(
                initialValue: _selectedSourceFilter,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: l10n.cardInfoTriggerDetailLabel,
                ),
                items: [
                  for (final filter in SourceFilter.values)
                    DropdownMenuItem(
                      value: filter,
                      child: Text(filter.name),
                    ),
                ],
                onChanged: (value) =>
                    setState(() => _selectedSourceFilter = value),
              ),
            ],

            // Einzelziel-Bedingung
            if (supportsSingleTargetCondition(_selectedTrigger))
              CheckboxListTile(
                value: _singleTarget,
                onChanged: (value) =>
                    setState(() => _singleTarget = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.cardInfoSingleTargetLabel),
              ),

            // Schadenswerte
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _damageAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.cardInfoDamageAmountLabel,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                if (_selectedTrigger == TriggerType.staticDamageModifier) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 90,
                    child: TextField(
                      controller: _damageMultiplierController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.cardInfoDamageMultiplierLabel,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 90,
                    child: TextField(
                      controller: _damageMinimumController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.cardInfoDamageMinimumLabel,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
                if (_selectedTrigger != TriggerType.staticDamageModifier &&
                    _selectedTrigger != TriggerType.spellDealsDamage &&
                    _damageAmountController.text.trim().isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<DamageTarget>(
                      initialValue: _selectedDamageTarget,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l10n.cardInfoDamageTargetLabel,
                      ),
                      items: [
                        for (final target in DamageTarget.values)
                          DropdownMenuItem(
                            value: target,
                            child: Text(target.name),
                          ),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedDamageTarget = value),
                    ),
                  ),
                ],
              ],
            ),

            // Replacement-Scope
            if (_selectedTrigger == TriggerType.staticDamageModifier) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<ReplacementScope>(
                initialValue: _selectedReplacementScope,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: l10n.cardInfoReplacementScopeLabel,
                ),
                items: [
                  for (final scope in ReplacementScope.values)
                    DropdownMenuItem(
                      value: scope,
                      child: Text(
                        scope == ReplacementScope.all
                            ? l10n.cardInfoReplacementScopeAll
                            : l10n.cardInfoReplacementScopeOpponentOnly,
                      ),
                    ),
                ],
                onChanged: (v) =>
                    setState(() => _selectedReplacementScope = v),
              ),
            ],

            // Dynamischer Schaden
            if (_selectedTrigger == TriggerType.spellDealsDamage)
              CheckboxListTile(
                value: _dynamicDamage,
                onChanged: (v) =>
                    setState(() => _dynamicDamage = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.cardInfoDynamicDamageLabel),
              ),

            // Kurztexte
            const SizedBox(height: 8),
            TextField(
              controller: _shortLabelController,
              decoration: InputDecoration(
                labelText: l10n.cardInfoShortLabelLabel,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _shortLabelEnController,
              decoration: InputDecoration(
                labelText: l10n.cardInfoShortLabelEnLabel,
              ),
            ),

            // Beschreibung + Speichern
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: l10n.cardInfoEffectDescriptionLabel,
                    ),
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: l10n.cardInfoAddEffect,
                  onPressed: _addEffect,
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
