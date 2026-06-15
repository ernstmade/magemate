import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/deck_providers.dart';
import '../../shared/models/trigger_type.dart';
import 'effect_tile.dart';

/// Zeigt in einem Modal alle Effekte, die ausgelöst werden, wenn ein
/// Instant/Sorcery gespielt wird – inklusive der Folge-Trigger, die durch
/// dadurch verursachten Schaden entstehen (z.B. Chandra's Incinerator,
/// Imodane).
Future<void> showCastSpellEffectsSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _CastSpellEffectsSheet(),
  );
}

class _CastSpellEffectsSheet extends ConsumerWidget {
  const _CastSpellEffectsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.castSpellSheetTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _Section(
                title: l10n.castSpellSectionCast,
                hint: l10n.castSpellSectionCastHint,
                trigger: TriggerType.castSpell,
              ),
              const SizedBox(height: 16),
              _Section(
                title: l10n.castSpellSectionDamage,
                hint: l10n.castSpellSectionDamageHint,
                trigger: TriggerType.dealsNoncombatDamage,
              ),
              const SizedBox(height: 16),
              _Section(
                title: l10n.castSpellSectionSpellDamage,
                hint: l10n.castSpellSectionSpellDamageHint,
                trigger: TriggerType.spellDealsDamage,
              ),
              const SizedBox(height: 16),
              _Section(
                title: l10n.castSpellSectionStaticModifiers,
                hint: l10n.castSpellSectionStaticModifiersHint,
                trigger: TriggerType.staticDamageModifier,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends ConsumerWidget {
  const _Section({
    required this.title,
    required this.hint,
    required this.trigger,
  });

  final String title;
  final String hint;
  final TriggerType trigger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final effects = ref.watch(effectsForTriggerProvider(trigger));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 2),
        Text(hint, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        effects.when(
          data: (entries) {
            if (entries.isEmpty) {
              return Text(l10n.noMatchingEffects);
            }
            return Column(
              children: [
                for (final (definition, effect) in entries)
                  EffectTile(
                    effect: effect,
                    cardName: definition.name,
                    contentPadding: EdgeInsets.zero,
                  ),
              ],
            );
          },
          error: (e, _) => Text('Error: $e'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
