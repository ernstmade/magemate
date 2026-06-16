import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/deck_providers.dart';
import '../../shared/models/trigger_type.dart';
import '../../shared/widgets/mana_symbol.dart';
import 'effect_tile.dart';

Future<void> showCardInfoSheet(
  BuildContext context,
  CardDefinition definition,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.8,
    ),
    builder: (context) => _CardInfoSheet(definition: definition),
  );
}

class _CardInfoSheet extends ConsumerStatefulWidget {
  const _CardInfoSheet({required this.definition});

  final CardDefinition definition;

  @override
  ConsumerState<_CardInfoSheet> createState() => _CardInfoSheetState();
}

class _CardInfoSheetState extends ConsumerState<_CardInfoSheet> {
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
    final damageMinimum = int.tryParse(
      _damageMinimumController.text.trim(),
    );
    await ref
        .read(deckRepositoryProvider)
        .addEffect(
          definition.id,
          _selectedTrigger,
          shortLabel,
          shortLabelEn,
          description,
          triggerDetail: triggerDetail,
          extraConditions: _singleTarget
              ? {EffectCondition.singleTarget}
              : {},
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
    final isDe = Localizations.localeOf(context).languageCode == 'de';
    final effects = ref.watch(effectsForCardDefinitionProvider(definition.id));

    final powerToughness =
        (definition.power != null || definition.toughness != null)
        ? '${definition.power ?? '-'}/${definition.toughness ?? '-'}'
        : null;
    final hasTypeRow =
        (definition.typeLine?.isNotEmpty ?? false) || powerToughness != null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ColorIdentityDot(colors: definition.colors),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isDe
                              ? (definition.printedName ?? definition.name)
                              : definition.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (isDe && definition.printedName != null)
                          Text(
                            definition.name,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (definition.manaCost != null &&
                      definition.manaCost!.isNotEmpty)
                    ManaCostIcons(manaCost: definition.manaCost!),
                ],
              ),
              if (hasTypeRow) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    if ((isDe
                            ? (definition.printedTypeLine ?? definition.typeLine)
                            : definition.typeLine)
                        ?.isNotEmpty ??
                        false)
                      Expanded(
                        child: Text(
                          isDe
                              ? (definition.printedTypeLine ??
                                    definition.typeLine!)
                              : definition.typeLine!,
                        ),
                      ),
                    if (powerToughness != null) Text(powerToughness),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              if (!hasTypeRow && definition.oracleText == null)
                Text(l10n.cardInfoNoData),
              if (definition.printedText != null ||
                  definition.oracleText != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.cardInfoOracleText,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  isDe
                      ? (definition.printedText ?? definition.oracleText!)
                      : (definition.oracleText ?? definition.printedText!),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                l10n.cardInfoEffectsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              effects.when(
                data: (effects) {
                  if (effects.isEmpty) {
                    return Text(l10n.cardInfoNoEffects);
                  }
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
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TriggerType>(
                      initialValue: _selectedTrigger,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l10n.cardInfoTriggerLabel,
                      ),
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
                  ),
                ],
              ),
              if (triggerDetailKind(_selectedTrigger) ==
                  TriggerDetailKind.spellCategory) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<SpellCategory>(
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
                    ),
                  ],
                ),
              ],
              if (triggerDetailKind(_selectedTrigger) ==
                  TriggerDetailKind.sourceFilter) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<SourceFilter>(
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
                    ),
                  ],
                ),
              ],
              if (supportsSingleTargetCondition(_selectedTrigger))
                CheckboxListTile(
                  value: _singleTarget,
                  onChanged: (value) =>
                      setState(() => _singleTarget = value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.cardInfoSingleTargetLabel),
                ),
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
                  const SizedBox(width: 8),
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
                      _damageAmountController.text.trim().isNotEmpty)
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
              ),
              // Replacement-Scope: nur bei staticDamageModifier
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
              // Dynamischer Schaden: nur bei spellDealsDamage (z.B. Imodane)
              if (_selectedTrigger == TriggerType.spellDealsDamage)
                CheckboxListTile(
                  value: _dynamicDamage,
                  onChanged: (v) =>
                      setState(() => _dynamicDamage = v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.cardInfoDynamicDamageLabel),
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
