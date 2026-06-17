import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/deck_providers.dart';
import '../../shared/widgets/mana_symbol.dart';
import '../../shared/widgets/oracle_text.dart';
import '../../shared/widgets/star_rating.dart';
import 'card_effect_edit_screen.dart';
import 'effect_tile.dart';

Future<void> showCardInfoSheet(
  BuildContext context,
  CardDefinition definition,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.8,
    ),
    builder: (context) => _CardInfoSheet(definition: definition),
  );
}

class _CardInfoSheet extends ConsumerWidget {
  const _CardInfoSheet({required this.definition});

  final CardDefinition definition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final isDe = Localizations.localeOf(context).languageCode == 'de';
    final effects = ref.watch(effectsForCardDefinitionProvider(definition.id));

    final powerToughness =
        (definition.power != null || definition.toughness != null)
        ? '${definition.power ?? '-'}/${definition.toughness ?? '-'}'
        : null;
    final hasTypeRow =
        (definition.typeLine?.isNotEmpty ?? false) || powerToughness != null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Kopfzeile: Farbe, Name, Manakosten, Edit-Button ──────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ColorIdentityDot(colors: definition.colors),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isDe
                              ? (definition.printedName ?? definition.name)
                              : definition.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (isDe && definition.printedName != null)
                          Text(
                            definition.name,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (definition.manaCost != null &&
                          definition.manaCost!.isNotEmpty)
                        ManaCostIcons(manaCost: definition.manaCost!),
                      _RatingChip(definition: definition),
                    ],
                  ),
                ],
              ),

              // ── Typzeile + P/T ────────────────────────────────────────────
              if (hasTypeRow) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    if ((isDe
                                ? (definition.printedTypeLine ??
                                      definition.typeLine)
                                : definition.typeLine)
                            ?.isNotEmpty ??
                        false)
                      Expanded(
                        child: Text(
                          isDe
                              ? (definition.printedTypeLine ??
                                    definition.typeLine!)
                              : definition.typeLine!,
                        ),
                      ),
                    if (powerToughness != null) Text(powerToughness),
                  ],
                ),
              ],

              // ── Oracle-Text ───────────────────────────────────────────────
              if (!hasTypeRow && definition.oracleText == null)
                Text(l10n.cardInfoNoData),
              if (definition.printedText != null ||
                  definition.oracleText != null) ...[
                const SizedBox(height: 8),
                OracleText(
                  isDe
                      ? (definition.printedText ?? definition.oracleText!)
                      : (definition.oracleText ?? definition.printedText!),
                ),
              ],

              // ── Effektliste ───────────────────────────────────────────────
              const SizedBox(height: 16),
              Text(
                l10n.cardInfoEffectsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              effects.when(
                data: (effects) {
                  if (effects.isEmpty) return Text(l10n.cardInfoNoEffects);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final effect in effects)
                        EffectTile(
                          effect: effect,
                          definition: definition,
                          cardName: effect.trigger,
                          subtitleFirst: true,
                          contentPadding: EdgeInsets.zero,
                          onDelete: () => ref
                              .read(deckRepositoryProvider)
                              .deleteEffect(effect.id),
                        ),
                    ],
                  );
                },
                error: (e, _) => Text('Error: $e'),
                loading: () => const SizedBox(
                  height: 24,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),

              // ── Edit-Button ───────────────────────────────────────────────
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l10n.cardInfoEditEffects),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          CardEffectEditScreen(definition: definition),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Zeigt die Bewertung kompakt (Sterne + Zahl) und öffnet per Tap ein Modal
/// zum Ändern der Bewertung.
class _RatingChip extends ConsumerWidget {
  const _RatingChip({required this.definition});

  final CardDefinition definition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rating = definition.rating;

    return GestureDetector(
      onTap: () => _showRatingDialog(context, ref, definition),
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: rating == null
            ? Icon(
                Icons.star_border,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StarRatingDisplay(rating: rating, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    _formatRating(rating),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
      ),
    );
  }

  String _formatRating(double r) {
    // Ganze Zahl ohne Nachkommastelle, sonst mit einer Nachkommastelle
    return r == r.truncateToDouble() ? r.toInt().toString() : r.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '');
  }
}

Future<void> _showRatingDialog(
  BuildContext context,
  WidgetRef ref,
  CardDefinition definition,
) async {
  double current = definition.rating ?? 0;
  await showDialog<void>(
    context: context,
    builder: (context) => _RatingDialog(
      initial: current,
      onSave: (value) => ref
          .read(deckRepositoryProvider)
          .updateRating(definition.id, value == 0 ? null : value),
    ),
  );
}

class _RatingDialog extends StatefulWidget {
  const _RatingDialog({required this.initial, required this.onSave});

  final double initial;
  final void Function(double) onSave;

  @override
  State<_RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<_RatingDialog> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return AlertDialog(
      title: Text(l10n.cardRatingTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StarRatingDisplay(rating: _value, size: 28),
          const SizedBox(height: 8),
          Slider(
            min: 0,
            max: 5.5,
            divisions: 22,
            value: _value,
            label: _value == 0 ? '–' : _value.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), ''),
            onChanged: (v) => setState(() => _value = v),
          ),
          Text(
            _value == 0 ? l10n.cardRatingNone : '${_value.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '')} / 5.5',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            widget.onSave(_value);
            Navigator.of(context).pop();
          },
          child: Text(l10n.actionSave),
        ),
      ],
    );
  }
}
