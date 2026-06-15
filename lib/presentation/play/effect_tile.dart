import 'package:flutter/material.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/trigger_type.dart';
import '../../shared/models/trigger_style.dart';

/// Stellt einen Karteneffekt dar: Kurzschreibweise prominent, der
/// ausführliche Text steckt hinter einem Info-Icon.
class EffectTile extends StatelessWidget {
  const EffectTile({
    super.key,
    required this.effect,
    this.cardName,
    this.onDelete,
    this.contentPadding,
    this.subtitleFirst = false,
  });

  final CardEffect effect;
  final String? cardName;
  final VoidCallback? onDelete;
  final EdgeInsetsGeometry? contentPadding;

  /// Zeigt [cardName] als Titel (erste Zeile) und den Effekt als Untertitel
  /// (zweite Zeile), statt umgekehrt.
  final bool subtitleFirst;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final shortLabel = effect.shortLabel.trim();
    final title = shortLabel.isNotEmpty ? shortLabel : effect.description;
    final trigger = TriggerType.values.firstWhere(
      (t) => t.name == effect.trigger,
      orElse: () => TriggerType.castSpell,
    );
    final style = triggerStyle(trigger);

    return ListTile(
      contentPadding: contentPadding,
      leading: Icon(style.icon, color: style.color),
      title: Text(subtitleFirst && cardName != null ? cardName! : title),
      subtitle: cardName == null
          ? null
          : Text(subtitleFirst ? title : cardName!),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: l10n.cardInfo,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(cardName ?? title),
                content: Text(effect.description),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.actionClose),
                  ),
                ],
              ),
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
