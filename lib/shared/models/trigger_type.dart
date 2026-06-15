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

/// Detaillierung für `TriggerType.castSpell`: auf welche Art von
/// Zauberspruch ein Effekt reagiert.
enum SpellCategory {
  // Nur Instant/Sorcery (z.B. Guttersnipe, Caldera Pyremaw)
  instantOrSorcery,
  // Jeder Nicht-Kreatur-Zauberspruch (z.B. Coruscation Mage, Longshot)
  noncreatureSpell,
}
