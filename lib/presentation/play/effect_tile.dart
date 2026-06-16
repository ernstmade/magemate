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
    this.definition,
    this.cardName,
    this.onDelete,
    this.contentPadding,
    this.subtitleFirst = false,
    this.extraInfo,
  });

  final CardEffect effect;

  /// Karten-Definition für den Oracle-Text im Info-Dialog. Wenn gesetzt,
  /// wird der Original-Kartentext (DE oder EN je nach Locale) verwendet
  /// statt des manuell eingetragenen [CardEffect.description].
  final CardDefinition? definition;

  final String? cardName;
  final VoidCallback? onDelete;
  final EdgeInsetsGeometry? contentPadding;

  /// Zeigt [cardName] als Titel (erste Zeile) und den Effekt als Untertitel
  /// (zweite Zeile), statt umgekehrt.
  final bool subtitleFirst;

  /// Zusätzliche Erklärung (z.B. wann/warum dieser Effekt in diesem Kontext
  /// triggert), die im Info-Dialog unter dem Kartentext angezeigt wird.
  final String? extraInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final isDe = locale == 'de';

    // Locale-abhängige Kurzschreibweise
    final shortLabelDe = effect.shortLabel.trim();
    final shortLabelEn = (effect.shortLabelEn ?? '').trim();
    final localShortLabel = isDe
        ? shortLabelDe
        : (shortLabelEn.isNotEmpty ? shortLabelEn : shortLabelDe);
    final title = localShortLabel.isNotEmpty
        ? localShortLabel
        : effect.description;

    final trigger = TriggerType.values.firstWhere(
      (t) => t.name == effect.trigger,
      orElse: () => TriggerType.castSpell,
    );
    final style = triggerStyle(trigger);
    final conditions = (effect.extraConditions ?? '')
        .split(',')
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toList();
    final hasSingleTarget = conditions.contains(
      EffectCondition.singleTarget.name,
    );
    final triggerDetail = effect.triggerDetail;
    final lvl23Line = [?cardName, ?triggerDetail].join(' · ');

    final theme = Theme.of(context);
    final lvl23Style = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    // Oracle-Text für den Info-Dialog: Kartentext bevorzugen (DE/EN je nach
    // Locale), Fallback auf manuell eingetragene description.
    final def = definition;
    final String infoText;
    if (def != null) {
      infoText = isDe
          ? (def.printedText ?? def.oracleText ?? effect.description)
          : (def.oracleText ?? def.printedText ?? effect.description);
    } else {
      infoText = effect.description;
    }

    // Dialog-Titel: bei subtitleFirst den Effektnamen, sonst den Kartennamen
    final dialogTitle = subtitleFirst
        ? title
        : (def != null
              ? (isDe
                    ? (def.printedName ?? def.name)
                    : def.name)
              : (cardName ?? title));

    return ListTile(
      contentPadding: contentPadding,
      leading: Icon(style.icon, color: style.color),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (lvl23Line.isNotEmpty) Text(lvl23Line, style: lvl23Style),
          Text(subtitleFirst ? '→ $title' : title),
        ],
      ),
      subtitle: hasSingleTarget
          ? Text(
              l10n.effectConditionSingleTarget,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: l10n.cardInfo,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(dialogTitle),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(infoText),
                    if (extraInfo != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        extraInfo!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
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
