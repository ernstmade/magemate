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

/// Liefert Icon und Farbe für die Kategorie, zu der [trigger] gehört.
TriggerStyle triggerStyle(TriggerType trigger) {
  switch (trigger) {
    // Phasen / Steps
    case TriggerType.upkeep:
    case TriggerType.draw:
    case TriggerType.endStep:
      return const TriggerStyle(Icons.schedule, Colors.blue);

    // Zaubersprüche / Stack
    case TriggerType.castSpell:
    case TriggerType.spellResolved:
      return const TriggerStyle(Icons.auto_fix_high, Colors.purple);

    // Kreaturen-Events
    case TriggerType.enterBattlefield:
      return const TriggerStyle(Icons.arrow_circle_right, Colors.green);

    case TriggerType.leaveBattlefield:
      return const TriggerStyle(Icons.arrow_circle_left, Colors.green);

    case TriggerType.dies:
      return const TriggerStyle(Symbols.skull, Colors.red);

    case TriggerType.blocks:
      return const TriggerStyle(Icons.shield_moon, Colors.orange);

    case TriggerType.attacks:
      return const TriggerStyle(Symbols.swords, Colors.red);

    // Schaden
    case TriggerType.dealsCombatDamage:
    case TriggerType.spellDealsDamage:
    case TriggerType.staticDamageModifier:
      return const TriggerStyle(Icons.local_fire_department, Colors.red);

    case TriggerType.dealsNoncombatDamage:
      return const TriggerStyle(Symbols.emergency_heat, Colors.red);

    case TriggerType.takesDamage:
      return const TriggerStyle(Icons.water_drop, Colors.red);

    // Karten / Hand
    case TriggerType.cardDrawn:
    case TriggerType.discard:
      return const TriggerStyle(Icons.style, Colors.teal);

    // Leben
    case TriggerType.lifeGain:
    case TriggerType.lifeLoss:
      return const TriggerStyle(Icons.favorite, Colors.green);

    // Land
    case TriggerType.landfall:
      return const TriggerStyle(Icons.terrain, Colors.brown);
  }
}
