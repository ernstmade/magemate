import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'trigger_type.dart';

/// Icon + Farbe für einen [TriggerType], um Effekte in der UI nach
/// Trigger-Kategorie einzufärben.
class TriggerStyle {
  const TriggerStyle(this.icon, this.color);

  final IconData icon;
  final Color color;

  @override
  bool operator ==(Object other) =>
      other is TriggerStyle && other.icon == icon && other.color == color;

  @override
  int get hashCode => Object.hash(icon, color);
}

// ─── Trigger-Klassen ─────────────────────────────────────────────────────────

/// Übergreifende Trigger-Klasse für Navigation und Trennstriche auf dem
/// Trigger-Screen. Jede Klasse fasst thematisch verwandte [TriggerType]s
/// zusammen und hat ein einheitliches Icon + Farbe für die Klassen-Chips.
class TriggerGroupDef {
  const TriggerGroupDef({
    required this.label,
    required this.icon,
    required this.color,
    required this.triggers,
  });

  final String label;
  final IconData icon;
  final Color color;
  final List<TriggerType> triggers;
}

/// Geordnete Trigger-Klassen. Reihenfolge bestimmt sowohl die Chip-Reihe oben
/// als auch die Abschnitt-Reihenfolge in der Liste.
///
///   0  Replacement   – statische Schadensmodifikatoren (orange)
///   1  Rundenbasiert – Upkeep, Draw, End Step (grau)
///   2  Spruchbasiert – Cast, Resolve, Spell Damage, Noncombat, Landfall (lila)
///   3  Kampfbasiert  – Angriff, Block, Kampfschaden, Sterben, Abgang (rot)
///   4  Ressourcen    – Leben, Karten, Hand (grün)
const triggerGroupDefs = <TriggerGroupDef>[
  TriggerGroupDef(
    label: 'Replacement',
    icon: Icons.local_fire_department,
    color: Colors.orange,
    triggers: [TriggerType.staticDamageModifier],
  ),
  TriggerGroupDef(
    label: 'Rundenbasiert',
    icon: Icons.schedule,
    color: Colors.grey,
    triggers: [TriggerType.upkeep, TriggerType.draw, TriggerType.endStep],
  ),
  TriggerGroupDef(
    label: 'Spruchbasiert',
    icon: Icons.auto_fix_high,
    color: Colors.purple,
    triggers: [
      TriggerType.castSpell,
      TriggerType.spellResolved,
      TriggerType.spellDealsDamage,
      TriggerType.dealsNoncombatDamage,
      TriggerType.landfall,
    ],
  ),
  TriggerGroupDef(
    label: 'Kampfbasiert',
    icon: Symbols.swords,
    color: Colors.red,
    triggers: [
      TriggerType.attacks,
      TriggerType.blocks,
      TriggerType.dealsCombatDamage,
      TriggerType.takesDamage,
      TriggerType.dies,
      TriggerType.leaveBattlefield,
    ],
  ),
  TriggerGroupDef(
    label: 'Ressourcen',
    icon: Icons.favorite,
    color: Colors.green,
    triggers: [
      TriggerType.lifeGain,
      TriggerType.lifeLoss,
      TriggerType.cardDrawn,
      TriggerType.discard,
    ],
  ),
];

// ─── Einzel-Trigger-Styles ───────────────────────────────────────────────────

/// Liefert Icon und Farbe für einen einzelnen [TriggerType].
/// Die Farbe orientiert sich an der übergeordneten [TriggerGroupDef].
TriggerStyle triggerStyle(TriggerType trigger) {
  switch (trigger) {
    // Replacement
    case TriggerType.staticDamageModifier:
      return const TriggerStyle(Icons.local_fire_department, Colors.orange);

    // Rundenbasiert
    case TriggerType.upkeep:
    case TriggerType.draw:
    case TriggerType.endStep:
      return const TriggerStyle(Icons.schedule, Colors.grey);

    // Spruchbasiert
    case TriggerType.castSpell:
    case TriggerType.spellResolved:
      return const TriggerStyle(Icons.auto_fix_high, Colors.purple);

    case TriggerType.spellDealsDamage:
      return const TriggerStyle(Icons.local_fire_department, Colors.purple);

    case TriggerType.dealsNoncombatDamage:
      return const TriggerStyle(Symbols.emergency_heat, Colors.purple);

    case TriggerType.landfall:
      return const TriggerStyle(Icons.terrain, Colors.purple);

    // Kampfbasiert
    case TriggerType.attacks:
      return const TriggerStyle(Symbols.swords, Colors.red);

    case TriggerType.blocks:
      return const TriggerStyle(Icons.shield_moon, Colors.red);

    case TriggerType.dealsCombatDamage:
      return const TriggerStyle(Icons.local_fire_department, Colors.red);

    case TriggerType.takesDamage:
      return const TriggerStyle(Icons.water_drop, Colors.red);

    case TriggerType.dies:
      return const TriggerStyle(Symbols.skull, Colors.red);

    case TriggerType.leaveBattlefield:
      return const TriggerStyle(Icons.arrow_circle_left, Colors.red);

    // Ressourcen
    case TriggerType.lifeGain:
    case TriggerType.lifeLoss:
      return const TriggerStyle(Icons.favorite, Colors.green);

    case TriggerType.cardDrawn:
    case TriggerType.discard:
      return const TriggerStyle(Icons.style, Colors.green);

    // enterBattlefield: kein aktiver Scope im Trigger-Screen, bleibt grün
    case TriggerType.enterBattlefield:
      return const TriggerStyle(Icons.arrow_circle_right, Colors.green);
  }
}
