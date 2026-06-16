/// Strukturierte, vordefinierte Trigger-Kategorien.
///
/// Effekte werden einem oder mehreren dieser Trigger zugeordnet, statt dass
/// jede Karte ihre eigene Freitext-Logik braucht. Liste wird as-we-go um
/// weitere MTG-Trigger ergänzt.
enum TriggerType {
  // Phasen / Steps
  upkeep,
  draw,
  endStep,

  // Zaubersprüche / Stack
  //
  // Wichtige Abgrenzung:
  // - castSpell: Reaktion einer (anderen) Karte darauf, dass IRGENDEIN
  //   Spruch (passender Kategorie, s. SpellCategory) gespielt wird, z.B.
  //   Guttersnipe "Whenever you cast an instant or sorcery spell, ...".
  // - spellResolved: Der EIGENE Effekt eines Instant/Sorcery, der eintritt,
  //   wenn DIESER Spruch aufgelöst wird, z.B. Boltwave "deals 3 damage to
  //   each opponent". Wird im "Gespielt"-Sheet oben separat angezeigt.
  castSpell,
  spellResolved,

  // Kreaturen
  enterBattlefield,
  leaveBattlefield,
  dies,
  attacks,
  blocks,
  dealsCombatDamage,
  takesDamage,
  dealsNoncombatDamage,
  spellDealsDamage,

  // Sonstiges
  landfall,
  lifeGain,
  lifeLoss,
  cardDrawn,
  discard,

  // Statische, dauerhaft aktive Modifikatoren (kein Einzel-Event, aber
  // relevant zu wissen, wenn man auf Schaden o.ä. schaut)
  staticDamageModifier,
}

/// Lvl3-Detail für `TriggerType.castSpell` / `TriggerType.spellDealsDamage`:
/// auf welche Art von Zauberspruch ein Effekt reagiert.
enum SpellCategory {
  // Nur Instant/Sorcery (z.B. Guttersnipe, Caldera Pyremaw, Satyr Firedancer)
  instantOrSorcery,
  // Jeder Nicht-Kreatur-Zauberspruch (z.B. Coruscation Mage, Longshot)
  noncreatureSpell,
}

/// Lvl3-Detail für `TriggerType.staticDamageModifier` /
/// `TriggerType.dealsNoncombatDamage`: welche Quellen der Effekt betrifft.
enum SourceFilter {
  // Nur rote Quellen (z.B. Torbran, Ojer Axonil)
  redSource,
  // Jede Quelle (z.B. Sawhorn Nemesis, Chandra's Incinerator)
  anySource,
}

/// Welche Art von Lvl3-Detail (falls überhaupt) zu einem Trigger passt.
enum TriggerDetailKind {
  spellCategory,
  sourceFilter,
  none,
}

/// Liefert die Art des Lvl3-Details für [trigger], s. [SpellCategory] und
/// [SourceFilter].
TriggerDetailKind triggerDetailKind(TriggerType trigger) {
  switch (trigger) {
    case TriggerType.castSpell:
    case TriggerType.spellDealsDamage:
      return TriggerDetailKind.spellCategory;
    case TriggerType.staticDamageModifier:
    case TriggerType.dealsNoncombatDamage:
      return TriggerDetailKind.sourceFilter;
    default:
      return TriggerDetailKind.none;
  }
}

/// Ob für [trigger] die Zusatzbedingung "nur bei Einzelziel" (s.
/// [EffectCondition.singleTarget]) sinnvoll angeboten werden soll.
bool supportsSingleTargetCondition(TriggerType trigger) {
  switch (trigger) {
    case TriggerType.castSpell:
    case TriggerType.spellResolved:
    case TriggerType.spellDealsDamage:
    case TriggerType.dealsNoncombatDamage:
      return true;
    default:
      return false;
  }
}

/// Ziel eines festen Schadenswerts ([CardEffects.damageAmount]). Wird genutzt,
/// um beim "Gespielt"-Sheet Summen pro Zielgruppe zu bilden.
enum DamageTarget {
  // Ein einzelner Gegner (z.B. Lightning Bolt, Brash Taunter)
  singleOpponent,
  // Jeder Gegner (z.B. Boltwave, Guttersnipe)
  eachOpponent,
  // Eine einzelne Kreatur/Permanent (z.B. Abrade, Volcanic Spite)
  singleCreature,
  // Jede Kreatur (z.B. Fiery Confluence Modus 1)
  eachCreature,
  // Die Kreaturen jedes Gegners (z.B. Tectonic Hazard)
  eachOpponentCreatures,
}

/// Prüft, ob das gespeicherte `triggerDetail` eines Effekts zur gerade
/// gespielten/betrachteten Karte passt.
///
/// - `SpellCategory.instantOrSorcery`: [typeLine] enthält "Instant" oder
///   "Sorcery".
/// - `SpellCategory.noncreatureSpell`: [typeLine] enthält nicht "Creature".
/// - `SourceFilter.redSource`: [colors] enthält "R".
/// - `SourceFilter.anySource` bzw. `null`: passt immer.
bool triggerDetailMatches(String? triggerDetail, {String? typeLine, String? colors}) {
  if (triggerDetail == null) return true;

  for (final category in SpellCategory.values) {
    if (category.name == triggerDetail) {
      final type = typeLine ?? '';
      switch (category) {
        case SpellCategory.instantOrSorcery:
          return type.contains('Instant') || type.contains('Sorcery');
        case SpellCategory.noncreatureSpell:
          return !type.contains('Creature');
      }
    }
  }

  for (final filter in SourceFilter.values) {
    if (filter.name == triggerDetail) {
      switch (filter) {
        case SourceFilter.redSource:
          return (colors ?? '').split(',').contains('R');
        case SourceFilter.anySource:
          return true;
      }
    }
  }

  return true;
}

/// Auf welche Ziele ein Replacement-Effekt (staticDamageModifier) wirkt.
///
/// - [all]: Gegner UND Kreaturen/Permanente von Gegnern (z.B. Torbran).
/// - [opponentOnly]: Nur Gegner als Spieler (z.B. Ojer Axonil).
enum ReplacementScope {
  all,
  opponentOnly,
}

/// Ob ein [DamageTarget] ein Spieler (Gegner) oder eine Kreatur ist.
bool isOpponentTarget(DamageTarget target) {
  switch (target) {
    case DamageTarget.singleOpponent:
    case DamageTarget.eachOpponent:
      return true;
    case DamageTarget.singleCreature:
    case DamageTarget.eachCreature:
    case DamageTarget.eachOpponentCreatures:
      return false;
  }
}

/// Orthogonale, optionale Zusatzbedingungen für einen Effekt. Mehrere Werte
/// werden kommagetrennt in `CardEffects.extraConditions` gespeichert. Liste
/// kann bei Bedarf erweitert werden, ohne dass eine neue Spalte/Migration
/// nötig ist.
enum EffectCondition {
  // Effekt greift nur, wenn der auslösende Spruch/Fähigkeit genau ein
  // einziges Ziel hatte (z.B. Imodane, Spinerock Tyrant).
  singleTarget,
}
