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
  final _shortLabelController = TextEditingController();
  final _descriptionController = TextEditingController();

  CardDefinition get definition => widget.definition;

  @override
  void dispose() {
    _shortLabelController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addEffect() async {
    final description = _descriptionController.text.trim();
    final shortLabel = _shortLabelController.text.trim();
    if (description.isEmpty) return;
    if (_selectedTrigger == TriggerType.castSpell &&
        _selectedSpellCategory == null) {
      return;
    }
    await ref
        .read(deckRepositoryProvider)
        .addEffect(
          definition.id,
          _selectedTrigger,
          shortLabel,
          description,
          spellCategory: _selectedTrigger == TriggerType.castSpell
              ? _selectedSpellCategory
              : null,
        );
    _shortLabelController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
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
                    child: Text(
                      definition.name,
                      style: Theme.of(context).textTheme.titleLarge,
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
                    if (definition.typeLine?.isNotEmpty ?? false)
                      Expanded(child: Text(definition.typeLine!)),
                    if (powerToughness != null) Text(powerToughness),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              if (!hasTypeRow && definition.oracleText == null)
                Text(l10n.cardInfoNoData),
              if (definition.oracleText != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.cardInfoOracleText,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(definition.oracleText!),
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
                            if (value != TriggerType.castSpell) {
                              _selectedSpellCategory = null;
                            }
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              if (_selectedTrigger == TriggerType.castSpell) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<SpellCategory>(
                        initialValue: _selectedSpellCategory,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l10n.cardInfoSpellCategoryLabel,
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
              const SizedBox(height: 8),
              TextField(
                controller: _shortLabelController,
                decoration: InputDecoration(
                  labelText: l10n.cardInfoShortLabelLabel,
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
