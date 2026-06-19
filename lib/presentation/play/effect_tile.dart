import 'package:flutter/material.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/trigger_style.dart';
import '../../shared/models/trigger_type.dart';
import '../../shared/widgets/oracle_text.dart';

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
    this.showLeadingIcon = true,
    this.extraInfo,
  });

  final CardEffect effect;

  /// Wenn gesetzt, wird das Oracle-Zitat (DE/EN je nach Locale) der Karte im
  /// Info-Dialog angezeigt — verbatim statt der gespeicherten description.
  final CardDefinition? definition;

  final String? cardName;
  final VoidCallback? onDelete;
  final EdgeInsetsGeometry? contentPadding;

  /// Zeigt [cardName] als Titel (erste Zeile) und den Effekt als Untertitel
  /// (zweite Zeile), statt umgekehrt.
  final bool subtitleFirst;

  /// Ob das Trigger-Icon links angezeigt werden soll. Standardmäßig true;
  /// kann auf false gesetzt werden, wenn das Icon bereits im übergeordneten
  /// Abschnitts-Header erscheint (z.B. TriggerEffectSection).
  final bool showLeadingIcon;

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
    final hasSingleTarget = conditions.contains(EffectCondition.singleTarget.name);
    final hasSingleCreatureTarget = conditions.contains(EffectCondition.singleCreatureTarget.name);
    final hasDamageToOpponent = conditions.contains(EffectCondition.damageToOpponent.name);
    final detailLabel = triggerDetailLabel(effect.triggerDetail, isDe: isDe);
    final conditionLabel = [
      if (hasSingleTarget) l10n.effectConditionSingleTarget,
      if (hasSingleCreatureTarget) l10n.effectConditionSingleCreatureTarget,
      if (hasDamageToOpponent) l10n.effectConditionDamageToOpponent,
    ].join(', ');
    final lvl23Line = [
      ?cardName,
      ?detailLabel,
      if (conditionLabel.isNotEmpty) conditionLabel,
    ].join(' · ');

    final theme = Theme.of(context);
    final lvl23Style = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    final def = definition;
    final String infoText;
    if (def != null) {
      final fullText = isDe
          ? (def.printedText ?? def.oracleText ?? effect.description)
          : (def.oracleText ?? def.printedText ?? effect.description);
      infoText = _relevantOracleLine(fullText, trigger);
    } else {
      infoText = effect.description;
    }

    // Im Karten-Info-Kontext (definition vorhanden) reicht das Zitat ohne Titel.
    final String? dialogTitle = def != null ? null : (cardName ?? title);

    return ListTile(
      contentPadding: contentPadding,
      leading: showLeadingIcon ? Icon(style.icon, color: style.color) : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (lvl23Line.isNotEmpty) Text(lvl23Line, style: lvl23Style),
          Text(subtitleFirst ? '→ $title' : title),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: l10n.cardInfo,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: dialogTitle != null ? Text(dialogTitle) : null,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OracleText(infoText),
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

/// Findet die relevante Zeile aus dem Oracle-Text für den gegebenen Trigger.
/// Splittet nach Zeilenumbrüchen und sucht nach trigger-spezifischen Keywords
/// (EN und DE). Findet sich keine passende Zeile, wird der gesamte Text zurückgegeben.
String _relevantOracleLine(String oracleText, TriggerType trigger) {
  final lines = oracleText
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();
  if (lines.length <= 1) return oracleText.trim();

  final keywords = _triggerKeywords(trigger);
  for (final line in lines) {
    final lower = line.toLowerCase();
    if (keywords.any((k) => lower.contains(k))) return line;
  }
  return oracleText.trim();
}

List<String> _triggerKeywords(TriggerType trigger) => switch (trigger) {
  TriggerType.enterBattlefield    => ['enters the battlefield', 'enters', 'kommt ins spiel', 'betritt das'],
  TriggerType.leaveBattlefield    => ['leaves the battlefield', 'verlässt das schlachtfeld'],
  TriggerType.dies                => ['dies', 'stirbt'],
  TriggerType.attacks             => ['attacks', 'angreift', 'greift an'],
  TriggerType.blocks              => ['blocks', 'blockt'],
  TriggerType.dealsCombatDamage   => ['deals combat damage', 'kampfschaden zufügt'],
  TriggerType.dealsNoncombatDamage => ['deals noncombat damage', 'nicht-kampfschaden', 'noncombat damage'],
  TriggerType.takesDamage         => ['is dealt damage', 'damage is dealt to', 'schaden zugefügt wird'],
  TriggerType.castSpell           => ['whenever you cast', 'when you cast', 'immer wenn du einen spruch', 'wann immer du'],
  TriggerType.spellResolved       => ['when a spell resolves', 'after a spell', 'wenn ein spruch aufgelöst'],
  TriggerType.spellDealsDamage    => ['a spell deals damage', 'spell deals damage', 'wenn ein spruch', 'spruch einem gegner'],
  TriggerType.upkeep              => ['beginning of your upkeep', 'at the beginning of your upkeep', 'zu beginn deines unterhalts'],
  TriggerType.draw                => ['beginning of your draw', 'at the beginning of your draw', 'zu beginn deiner ziehphase'],
  TriggerType.endStep             => ['beginning of your end step', 'at the beginning of the end step', 'zu beginn des endschritts'],
  TriggerType.landfall            => ['landfall', 'whenever a land enters', 'immer wenn ein land'],
  TriggerType.lifeGain            => ['whenever you gain life', 'immer wenn du leben gewinnst'],
  TriggerType.lifeLoss            => ['whenever you lose life', 'immer wenn du leben verlierst'],
  TriggerType.cardDrawn           => ['whenever you draw a card', 'whenever a player draws', 'immer wenn du eine karte ziehst'],
  TriggerType.discard             => ['whenever you discard', 'immer wenn du eine karte abwirfst'],
  TriggerType.staticDamageModifier => ['if a source would deal', 'damage that would be dealt', 'wenn eine quelle', 'schaden, der'],
};
