import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/deck_providers.dart';
import '../../shared/models/trigger_type.dart';
import '../../shared/widgets/trigger_effect_section.dart';
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
              _FilteredSection(
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
/// nach [DamageTarget]. Per Tap aufklappbar für die Detailrechnung.
class _DamageSummary extends ConsumerStatefulWidget {
  const _DamageSummary({required this.definition});

  final CardDefinition definition;

  @override
  ConsumerState<_DamageSummary> createState() => _DamageSummaryState();
}

class _DamageSummaryState extends ConsumerState<_DamageSummary> {
  final _expanded = <DamageTarget>{};

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final isDe = Localizations.localeOf(context).languageCode == 'de';
    final definition = widget.definition;

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

      contributions.putIfAbsent(target, () => []).add((cardName, base));
    }

    if (sums.isEmpty) return const SizedBox.shrink();

    final hasFollowUps = [
      ...noncombatEffects,
      ...spellDamageEffects,
    ].any((e) => triggerDetailMatches(
          e.$2.triggerDetail,
          typeLine: definition.typeLine,
          colors: definition.colors,
        ));

    String labelFor(DamageTarget target) => switch (target) {
          DamageTarget.singleOpponent =>
            l10n.castSpellDamageSummarySingleOpponent,
          DamageTarget.eachOpponent => l10n.castSpellDamageSummaryEachOpponent,
          DamageTarget.singleCreature =>
            l10n.castSpellDamageSummarySingleCreature,
          DamageTarget.eachCreature => l10n.castSpellDamageSummaryEachCreature,
          DamageTarget.eachOpponentCreatures =>
            l10n.castSpellDamageSummaryEachOpponentCreatures,
        };

    // Replacement-Zeilen in Rechenreihenfolge: 1. Minimum, 2. Additiv, 3. Multiplikativ.
    List<(String, String)> repLines(List<(CardDefinition, CardEffect)> reps) {
      final lines = <(String, String)>[];
      for (final (def, e) in reps) {
        if (e.damageMinimum != null && e.damageMinimum! > 0) {
          lines.add((isDe ? (def.printedName ?? def.name) : def.name, '↑${e.damageMinimum}'));
        }
      }
      for (final (def, e) in reps) {
        if (e.damageAmount != null && e.damageAmount != 0) {
          final amt = e.damageAmount!;
          lines.add((isDe ? (def.printedName ?? def.name) : def.name, '${amt >= 0 ? '+' : ''}$amt'));
        }
      }
      for (final (def, e) in reps) {
        if (e.damageMultiplier != null && e.damageMultiplier != 1) {
          lines.add((isDe ? (def.printedName ?? def.name) : def.name, '×${e.damageMultiplier}'));
        }
      }
      return lines;
    }

    // Pro Quellkarte eine Gruppe: (Kartenname, Basiswert, Replacement-Zeilen).
    // Replacements gelten je Quelle separat → jede Gruppe bekommt ihre eigene Kette.
    List<(String, String, List<(String, String)>)> detailGroups(
        DamageTarget target) {
      final reps = isOpponentTarget(target) ? matchingRepPairs : creatureRepPairs;
      final rl = repLines(reps);
      return [
        for (final entry in contributions[target] ?? <(String, int)>[])
          (entry.$1, '${entry.$2}', rl),
      ];
    }

    final theme = Theme.of(context);
    final summaryStyle = theme.textTheme.titleSmall;
    final detailStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in sums.entries) ...[
            // ── Zusammenfassungszeile (aufklappbar) ─────────────────────────
            InkWell(
              onTap: () => setState(() {
                if (_expanded.contains(entry.key)) {
                  _expanded.remove(entry.key);
                } else {
                  _expanded.add(entry.key);
                }
              }),
              child: Row(
                children: [
                  Expanded(
                    child: Text(labelFor(entry.key), style: summaryStyle),
                  ),
                  Text('${entry.value}', style: summaryStyle),
                  const SizedBox(width: 4),
                  Icon(
                    _expanded.contains(entry.key)
                        ? Icons.expand_less
                        : Icons.expand_more,
                    size: 18,
                  ),
                ],
              ),
            ),
            // ── Detailzeilen (aufgeklappt) ───────────────────────────────
            if (_expanded.contains(entry.key))
              ...() {
                final groups = detailGroups(entry.key);
                final widgets = <Widget>[];
                for (int i = 0; i < groups.length; i++) {
                  final (srcLabel, srcValue, reps) = groups[i];
                  if (i > 0 && reps.isNotEmpty) {
                    widgets.add(const SizedBox(height: 4));
                  }
                  // Quellkarte
                  widgets.add(Padding(
                    padding: const EdgeInsets.only(left: 16, top: 3),
                    child: Row(
                      children: [
                        Expanded(child: Text(srcLabel, style: detailStyle)),
                        Text(srcValue, style: detailStyle),
                      ],
                    ),
                  ));
                  // Replacement-Kette dieser Quelle (tiefer eingerückt)
                  for (final (repLabel, repValue) in reps) {
                    widgets.add(Padding(
                      padding: const EdgeInsets.only(left: 32, top: 2),
                      child: Row(
                        children: [
                          Expanded(child: Text(repLabel, style: detailStyle)),
                          Text(repValue, style: detailStyle),
                        ],
                      ),
                    ));
                  }
                }
                return widgets;
              }(),
            const SizedBox(height: 4),
          ],
          if (hasFollowUps) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16,
                    color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(l10n.followUpHint, style: summaryStyle),
              ],
            ),
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
        return TriggerEffectSection(
          title: l10n.castSpellSectionReplacement,
          trigger: TriggerType.staticDamageModifier,
          entries: matching,
          extraInfo: l10n.castSpellSectionReplacementHint,
          highlighted: true,
          showDividerAbove: true,
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
        return TriggerEffectSection(
          title: l10n.castSpellSectionOwnEffect,
          entries: resolveEffects.map((e) => (definition, e)).toList(),
          showDividerAbove: true,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 24),
        Padding(
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
              subtitleFirst: true,
              extraInfo: hint,
            ),
        ],
      ),
    ),
      ],
    );
  }
}

/// Wie [TriggerEffectSection], filtert aber zuerst nach [triggerDetailMatches]
/// für die gespielte Karte. Wird nur im Cast-Spell-Sheet benötigt.
class _FilteredSection extends ConsumerWidget {
  const _FilteredSection({
    required this.title,
    required this.hint,
    required this.trigger,
    required this.castDefinition,
  });

  final String title;
  final String hint;
  final TriggerType trigger;
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
        return TriggerEffectSection(
          title: title,
          entries: matching,
          extraInfo: hint,
          showDividerAbove: true,
        );
      },
      error: (e, _) => Text('Error: $e'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
