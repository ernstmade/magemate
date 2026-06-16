import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/deck_providers.dart';
import '../../shared/models/trigger_type.dart';
import 'effect_tile.dart';

/// Zeigt in einem Modal alle Effekte, die ausgelöst werden, wenn ein
/// Instant/Sorcery gespielt wird – inklusive der Folge-Trigger, die durch
/// dadurch verursachten Schaden entstehen (z.B. Chandra's Incinerator,
/// Imodane).
///
/// Aufbau (jeweils nur wenn vorhanden):
/// 1. Replacement-Effekte (gelten für alle folgenden Ebenen, z.B. Torbran)
/// 2. Eigener Effekt der gespielten Karte (spellResolved)
/// 3. Auf anderen Karten ausgelöste Effekte (castSpell)
/// 4. Folgeeffekte (dealsNoncombatDamage, spellDealsDamage)
Future<void> showCastSpellEffectsSheet(
  BuildContext context,
  CardDefinition definition,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.8,
    ),
    builder: (context) => _CastSpellEffectsSheet(definition: definition),
  );
}

class _CastSpellEffectsSheet extends ConsumerWidget {
  const _CastSpellEffectsSheet({required this.definition});

  final CardDefinition definition;

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
                l10n.cardInfoEffectsTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              _DamageSummary(definition: definition),
              const SizedBox(height: 8),
              _ReplacementEffectsBox(definition: definition),
              _OwnEffectSection(definition: definition),
              _Section(
                title: l10n.castSpellSectionCast,
                hint: l10n.castSpellSectionCastHint,
                trigger: TriggerType.castSpell,
                castDefinition: definition,
              ),
              _FollowUpSection(definition: definition),
            ],
          ),
        ),
      ),
    );
  }
}

/// Zeigt die Summe des fixen Schadens aller relevanten Effekte, gruppiert
/// nach [DamageTarget] (z.B. "Summe Schaden an jeden Gegner: 5"), mit der
/// Einzelrechnung darunter (z.B. "Volcanic Spite: 3 +2 (Torbran) = 5").
class _DamageSummary extends ConsumerWidget {
  const _DamageSummary({required this.definition});

  final CardDefinition definition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final isDe = Localizations.localeOf(context).languageCode == 'de';

    final ownEffects =
        ref.watch(effectsForCardDefinitionProvider(definition.id)).valueOrNull ??
        const [];
    final castSpellEffects =
        ref.watch(effectsForTriggerProvider(TriggerType.castSpell)).valueOrNull ??
        const [];
    final noncombatEffects =
        ref
            .watch(effectsForTriggerProvider(TriggerType.dealsNoncombatDamage))
            .valueOrNull ??
        const [];
    final spellDamageEffects =
        ref
            .watch(effectsForTriggerProvider(TriggerType.spellDealsDamage))
            .valueOrNull ??
        const [];
    final replacementEffects =
        ref
            .watch(effectsForTriggerProvider(TriggerType.staticDamageModifier))
            .valueOrNull ??
        const [];

    // (Kartenname, Effekt) – für Formelbeschriftung
    final relevant = <(String, CardEffect)>[
      for (final e in ownEffects.where(
        (e) => e.trigger == TriggerType.spellResolved.name,
      ))
        (definition.name, e),
      for (final (cardDef, effect) in [
        ...castSpellEffects,
        ...noncombatEffects,
        ...spellDamageEffects,
      ])
        if (triggerDetailMatches(
          effect.triggerDetail,
          typeLine: definition.typeLine,
          colors: definition.colors,
        ))
          (cardDef.name, effect),
    ];

    // Replacement-Effekte aufteilen nach Scope (mit CardDefinition für Labels)
    final matchingRepPairs = replacementEffects
        .where(
          (entry) => triggerDetailMatches(
            entry.$2.triggerDetail,
            typeLine: definition.typeLine,
            colors: definition.colors,
          ),
        )
        .toList(); // List<(CardDefinition, CardEffect)>

    final matchingReplacements = matchingRepPairs.map((p) => p.$2).toList();

    final creatureRepPairs = matchingRepPairs
        .where(
          (p) =>
              p.$2.replacementScope == null ||
              p.$2.replacementScope == ReplacementScope.all.name,
        )
        .toList();
    final creatureReplacements = creatureRepPairs.map((p) => p.$2).toList();

    // Berechnet floor → additiv → multiplikativ (optimale Reihenfolge).
    int applyReplacements(int base, List<CardEffect> replacements) {
      final floor = replacements.fold<int>(
        0,
        (m, e) =>
            e.damageMinimum != null && e.damageMinimum! > m
                ? e.damageMinimum!
                : m,
      );
      final bonus = replacements.fold<int>(
        0,
        (s, e) => s + (e.damageAmount ?? 0),
      );
      final mult = replacements.fold<int>(
        1,
        (p, e) => p * (e.damageMultiplier ?? 1),
      );
      final afterFloor = base < floor ? floor : base;
      return (afterFloor + bonus) * mult;
    }

    // Formel-String für eine einzelne Schadensquelle, z.B.:
    //   "Volcanic Spite: 3 +2 (Torbran) = 5"
    //   "Volcanic Spite: 3"  ← wenn keine Replacement-Änderung
    String termFormula(
      String label,
      int base,
      List<(CardDefinition, CardEffect)> repPairs,
    ) {
      final steps = <String>[];
      var current = base;

      // 1. Floor (Minimum, z.B. Ojer Axonil)
      int floorVal = 0;
      String? floorCardName;
      for (final (def, e) in repPairs) {
        if (e.damageMinimum != null && e.damageMinimum! > floorVal) {
          floorVal = e.damageMinimum!;
          floorCardName = def.name;
        }
      }
      if (current < floorVal) {
        steps.add('↑$floorVal ($floorCardName)');
        current = floorVal;
      }

      // 2. Additiv (z.B. Torbran +2)
      for (final (def, e) in repPairs) {
        final amt = e.damageAmount ?? 0;
        if (amt != 0) {
          steps.add('${amt >= 0 ? '+' : ''}$amt (${def.name})');
          current += amt;
        }
      }

      // 3. Multiplikativ (z.B. Fiendish Duo ×2)
      for (final (def, e) in repPairs) {
        final mult = e.damageMultiplier ?? 1;
        if (mult != 1) {
          steps.add('×$mult (${def.name})');
          current *= mult;
        }
      }

      if (steps.isEmpty) return '$label: $base';
      return '$label: $base ${steps.join(' ')} = $current';
    }

    // Effektiver Spell→Kreatur-Schaden (für dynamische Effekte wie Imodane)
    final spellCreatureDamage = relevant
        .where((r) => r.$2.trigger == TriggerType.spellResolved.name)
        .where((r) => r.$2.damageTarget == DamageTarget.singleCreature.name)
        .fold<int>(
          0,
          (sum, r) =>
              sum +
              applyReplacements(r.$2.damageAmount ?? 0, creatureReplacements),
        );

    final sums = <DamageTarget, int>{};
    // (label, base) pro Ziel – für Formelzeilen
    final contributions = <DamageTarget, List<(String, int)>>{};

    for (final (cardName, effect) in relevant) {
      final targetName = effect.damageTarget;
      if (targetName == null) continue;
      final target = DamageTarget.values.firstWhere(
        (t) => t.name == targetName,
        orElse: () => DamageTarget.singleOpponent,
      );

      final int base;
      if (effect.dynamicDamage ?? false) {
        base = spellCreatureDamage;
      } else {
        if (effect.damageAmount == null) continue;
        base = effect.damageAmount!;
      }
      if (base == 0) continue;

      final replacements =
          isOpponentTarget(target) ? matchingReplacements : creatureReplacements;
      final effective = applyReplacements(base, replacements);
      sums[target] = (sums[target] ?? 0) + effective;

      // Locale-abhängiges Label (shortLabel bevorzugt, sonst Kartenname)
      final shortLabelDe = effect.shortLabel.trim();
      final shortLabelEn = (effect.shortLabelEn ?? '').trim();
      final label = isDe
          ? (shortLabelDe.isNotEmpty ? shortLabelDe : cardName)
          : (shortLabelEn.isNotEmpty
                ? shortLabelEn
                : (shortLabelDe.isNotEmpty ? shortLabelDe : cardName));

      contributions.putIfAbsent(target, () => []).add((label, base));
    }

    if (sums.isEmpty) return const SizedBox.shrink();

    String labelFor(DamageTarget target) {
      switch (target) {
        case DamageTarget.singleOpponent:
          return l10n.castSpellDamageSummarySingleOpponent;
        case DamageTarget.eachOpponent:
          return l10n.castSpellDamageSummaryEachOpponent;
        case DamageTarget.singleCreature:
          return l10n.castSpellDamageSummarySingleCreature;
        case DamageTarget.eachCreature:
          return l10n.castSpellDamageSummaryEachCreature;
        case DamageTarget.eachOpponentCreatures:
          return l10n.castSpellDamageSummaryEachOpponentCreatures;
      }
    }

    final theme = Theme.of(context);
    final formulaStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in sums.entries) ...[
            Text(
              '${labelFor(entry.key)}: ${entry.value}',
              style: theme.textTheme.titleSmall,
            ),
            // Formelzeilen: immer wenn mehrere Quellen, oder wenn Replacements
            // den Wert verändert haben (steps.isNotEmpty → Label enthält "=")
            ...() {
              final contribs = contributions[entry.key] ?? [];
              final repPairs = isOpponentTarget(entry.key)
                  ? matchingRepPairs
                  : creatureRepPairs;
              // Einzeilig ohne Replacements und nur eine Quelle → trivial, kein Extra
              final alwaysShow =
                  contribs.length > 1 || repPairs.isNotEmpty;
              if (!alwaysShow) return const <Widget>[];
              return [
                for (final (label, base) in contribs)
                  Text(
                    termFormula(label, base, repPairs),
                    style: formulaStyle,
                  ),
              ];
            }(),
          ],
        ],
      ),
    );
  }
}

/// Replacement-Effekte (`staticDamageModifier`), die zur gespielten Karte
/// passen. Werden in einem farbigen Kästchen ganz oben angezeigt, da sie für
/// alle folgenden Ebenen (eigener Effekt, ausgelöste Effekte, Folgeeffekte)
/// gelten.
class _ReplacementEffectsBox extends ConsumerWidget {
  const _ReplacementEffectsBox({required this.definition});

  final CardDefinition definition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final effects = ref.watch(
      effectsForTriggerProvider(TriggerType.staticDamageModifier),
    );

    return effects.when(
      data: (entries) {
        final matching = entries
            .where(
              (entry) => triggerDetailMatches(
                entry.$2.triggerDetail,
                typeLine: definition.typeLine,
                colors: definition.colors,
              ),
            )
            .toList();
        if (matching.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Text(
                    l10n.castSpellSectionReplacement,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
                for (final (cardDefinition, effect) in matching)
                  EffectTile(
                    effect: effect,
                    definition: cardDefinition,
                    cardName: cardDefinition.name,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    extraInfo: l10n.castSpellSectionReplacementHint,
                  ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      },
      error: (e, _) => Text('Error: $e'),
      loading: () => const SizedBox.shrink(),
    );
  }
}

/// Der eigene Effekt der gespielten Karte (`spellResolved`).
class _OwnEffectSection extends ConsumerWidget {
  const _OwnEffectSection({required this.definition});

  final CardDefinition definition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final ownEffects = ref.watch(
      effectsForCardDefinitionProvider(definition.id),
    );

    return ownEffects.when(
      data: (effects) {
        final resolveEffects = effects
            .where((e) => e.trigger == TriggerType.spellResolved.name)
            .toList();
        if (resolveEffects.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.castSpellSectionOwnEffect,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              for (final effect in resolveEffects)
                EffectTile(
                  effect: effect,
                  definition: definition,
                  contentPadding: EdgeInsets.zero,
                ),
            ],
          ),
        );
      },
      error: (e, _) => Text('Error: $e'),
      loading: () => const SizedBox.shrink(),
    );
  }
}

/// Folgeeffekte: Effekte, die durch den von dieser Karte (oder ihren
/// Auslöse-Effekten) verursachten Schaden weitere Karten triggern, z.B.
/// `dealsNoncombatDamage` (Chandra's Incinerator) oder `spellDealsDamage`
/// (Satyr Firedancer, Imodane).
class _FollowUpSection extends ConsumerWidget {
  const _FollowUpSection({required this.definition});

  final CardDefinition definition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final noncombatEffects = ref.watch(
      effectsForTriggerProvider(TriggerType.dealsNoncombatDamage),
    );
    final spellDamageEffects = ref.watch(
      effectsForTriggerProvider(TriggerType.spellDealsDamage),
    );

    if (noncombatEffects.isLoading || spellDamageEffects.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final noncombatEntries =
        noncombatEffects.valueOrNull ?? const <(CardDefinition, CardEffect)>[];
    final spellDamageEntries =
        spellDamageEffects.valueOrNull ?? const <(CardDefinition, CardEffect)>[];

    final entries = <(CardDefinition, CardEffect, String)>[
      for (final (cardDefinition, effect) in noncombatEntries)
        if (triggerDetailMatches(
          effect.triggerDetail,
          typeLine: definition.typeLine,
          colors: definition.colors,
        ))
          (cardDefinition, effect, l10n.castSpellSectionDamageHint),
      for (final (cardDefinition, effect) in spellDamageEntries)
        if (triggerDetailMatches(
          effect.triggerDetail,
          typeLine: definition.typeLine,
          colors: definition.colors,
        ))
          (cardDefinition, effect, l10n.castSpellSectionSpellDamageHint),
    ];

    if (entries.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.castSpellSectionFollowUp,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          for (final (cardDefinition, effect, hint) in entries)
            EffectTile(
              effect: effect,
              definition: cardDefinition,
              cardName: cardDefinition.name,
              contentPadding: EdgeInsets.zero,
              extraInfo: hint,
            ),
        ],
      ),
    );
  }
}

class _Section extends ConsumerWidget {
  const _Section({
    required this.title,
    required this.hint,
    required this.trigger,
    required this.castDefinition,
  });

  final String title;
  final String hint;
  final TriggerType trigger;

  /// Die Karte, die gerade gespielt wird/wurde – für den Abgleich mit
  /// `triggerDetail` (z.B. Instant/Sorcery vs. Noncreature-Spell).
  final CardDefinition castDefinition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effects = ref.watch(effectsForTriggerProvider(trigger));

    return effects.when(
      data: (entries) {
        final matching = entries
            .where(
              (entry) => triggerDetailMatches(
                entry.$2.triggerDetail,
                typeLine: castDefinition.typeLine,
                colors: castDefinition.colors,
              ),
            )
            .toList();
        if (matching.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              for (final (definition, effect) in matching)
                EffectTile(
                  effect: effect,
                  definition: definition,
                  cardName: definition.name,
                  contentPadding: EdgeInsets.zero,
                  extraInfo: hint,
                ),
            ],
          ),
        );
      },
      error: (e, _) => Text('Error: $e'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
