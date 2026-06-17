import 'package:flutter/material.dart';
import '../../data/database/app_database.dart';
import '../models/trigger_style.dart';
import '../models/trigger_type.dart';
import '../../presentation/play/effect_tile.dart';

/// Rendert einen Trigger-Abschnitt: Überschrift (mit optionalem Icon) und
/// darunter die zugehörigen [EffectTile]s im subtitleFirst-Modus (Kartenname
/// oben, Kurztext mit Pfeil darunter).
///
/// Mit [highlighted] = true wird der gesamte Block in einem farbigen Container
/// dargestellt – für Replacement-Effekte (staticDamageModifier).
///
/// Wird sowohl auf dem Trigger-Screen als auch im Cast-Spell-Bottom-Sheet
/// verwendet, damit die Darstellung überall identisch ist.
class TriggerEffectSection extends StatelessWidget {
  const TriggerEffectSection({
    super.key,
    required this.title,
    required this.entries,
    this.trigger,
    this.extraInfo,
    this.highlighted = false,
    this.showCount = false,
    this.showDividerAbove = false,
  });

  final String title;
  final List<(CardDefinition, CardEffect)> entries;

  /// Wenn gesetzt, wird das passende Icon vor dem Titel angezeigt.
  final TriggerType? trigger;

  /// Optionaler Hinweistext, der im Info-Dialog unter dem Kartentext steht.
  final String? extraInfo;

  /// Hebt den Block mit einem farbigen Hintergrund hervor (Replacement-Stil).
  final bool highlighted;

  /// Zeigt die Anzahl der Einträge in Klammern hinter dem Titel.
  final bool showCount;

  /// Zeigt einen Divider oberhalb der Section (nur wenn entries nicht leer).
  final bool showDividerAbove;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();

    final style = trigger != null ? triggerStyle(trigger!) : null;
    final theme = Theme.of(context);
    final isDe = Localizations.localeOf(context).languageCode == 'de';

    final titleWidget = Row(
      children: [
        if (style != null) ...[
          Icon(
            style.icon,
            color: highlighted ? Colors.white : style.color,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          showCount ? '$title (${entries.length})' : title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: highlighted ? Colors.white : null,
          ),
        ),
      ],
    );

    final tiles = [
      for (final (definition, effect) in entries)
        EffectTile(
          effect: effect,
          cardName: isDe
              ? (definition.printedName ?? definition.name)
              : definition.name,
          contentPadding: highlighted
              ? const EdgeInsets.symmetric(horizontal: 8)
              : EdgeInsets.zero,
          subtitleFirst: true,
          showLeadingIcon: false,
          extraInfo: extraInfo,
        ),
    ];

    final content = highlighted
        ? Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: titleWidget,
                  ),
                  ...tiles,
                  const SizedBox(height: 4),
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget,
                const SizedBox(height: 4),
                ...tiles,
              ],
            ),
          );

    if (!showDividerAbove) return content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 24),
        content,
      ],
    );
  }
}
