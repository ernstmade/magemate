import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/active_deck_provider.dart';
import '../../providers/deck_providers.dart';
import '../../providers/locale_provider.dart';
import '../../shared/models/trigger_style.dart';
import '../../shared/models/trigger_type.dart';
import '../../data/parser/card_text_parser.dart';
import 'card_info_sheet.dart';
import 'cast_spell_sheet.dart';
import 'effect_suggestion_screen.dart';

bool isEquipmentOrAura(CardDefinition def) {
  final type = def.typeLine ?? '';
  return type.contains('Equipment') || type.contains('Aura');
}

/// Zeigt einen Dialog zur Auswahl der Zielkreatur. Gibt die gewählte
/// CardDefinition zurück, oder null wenn "Abnehmen" gewählt wurde.
Future<CardDefinition?> showEquipmentPicker(
  BuildContext context,
  int deckId,
  CardDefinition equipment,
  WidgetRef ref,
) async {
  // In-Play-Kreaturen laden (synchron aus letztem Watch-Wert)
  final grouped = ref.read(groupedCardsForDeckProvider(deckId));
  final creatures = grouped.valueOrNull
          ?.where(
            (g) =>
                g.board == 'main' &&
                g.inPlayCount > 0 &&
                (g.definition.typeLine?.contains('Creature') ?? false) &&
                g.definition.id != equipment.id,
          )
          .toList() ??
      [];

  final l10n = AppL10n.of(context);
  final isDe = Localizations.localeOf(context).languageCode == 'de';

  // Aktuelle Zuordnung
  final attachments =
      ref.read(attachmentsForDeckProvider(deckId)).valueOrNull ?? {};
  final currentTargetId = attachments[equipment.id];

  return showDialog<CardDefinition?>(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: Text(l10n.equipmentPickerTitle),
      children: [
        if (creatures.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              l10n.inPlayEmpty,
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
          ),
        for (final g in creatures)
          SimpleDialogOption(
            onPressed: () => Navigator.of(ctx).pop(g.definition),
            child: Row(
              children: [
                if (g.definition.id == currentTargetId)
                  const Icon(Icons.check, size: 18)
                else
                  const SizedBox(width: 18),
                const SizedBox(width: 8),
                Text(
                  isDe
                      ? (g.definition.printedName ?? g.definition.name)
                      : g.definition.name,
                ),
              ],
            ),
          ),
        if (currentTargetId != null) ...[
          const Divider(),
          SimpleDialogOption(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: Row(
              children: [
                const Icon(Icons.link_off, size: 18),
                const SizedBox(width: 8),
                Text(l10n.equipmentDetach),
              ],
            ),
          ),
        ],
      ],
    ),
  );
}

/// Sortieroptionen für die Kartenlisten in "Deck" und "Im Spiel".
enum SortMode { alphabetical, byTypeAlpha, byTypeCmc }

extension SortModeX on SortMode {
  bool get isByType => this == SortMode.byTypeAlpha || this == SortMode.byTypeCmc;
}

/// Speichert die Sortiereinstellung persistent und lädt sie beim Start.
/// Default: [SortMode.byTypeCmc].
class _SortModeNotifier extends StateNotifier<SortMode> {
  _SortModeNotifier() : super(SortMode.byTypeCmc) {
    _load();
  }

  static const _key = 'deck_sort_mode';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) {
      state = SortMode.values.firstWhere(
        (m) => m.name == saved,
        // 'byType' war der alte Name vor der Aufspaltung → CMC als Standard
        orElse: () => SortMode.byTypeCmc,
      );
    }
  }

  Future<void> set(SortMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}

final sortModeProvider =
    StateNotifierProvider<_SortModeNotifier, SortMode>((_) => _SortModeNotifier());

/// Reihenfolge der Typ-Zwischenüberschriften bei Sortierung "nach Typ". Hat
/// eine Karte mehrere dieser Typen, zählt der erste Treffer in dieser Liste.
const _typeCategoryOrder = ['Creature', 'Artifact', 'Instant', 'Sorcery', 'Land'];

/// Liefert die Sortier-/Überschriften-Kategorie aus der Typenzeile, z.B.
/// "Creature" für "Legendary Creature — Dragon".
String typeCategory(String? typeLine) {
  if (typeLine == null || typeLine.isEmpty) return '';
  const supertypes = {'Legendary', 'Basic', 'Snow', 'World', 'Ongoing', 'Token'};
  final mainPart = typeLine.split('—').first.trim();
  final words = mainPart
      .split(' ')
      .where((w) => !supertypes.contains(w))
      .toList();
  for (final type in _typeCategoryOrder) {
    if (words.contains(type)) return type;
  }
  return words.join(' ');
}

int _typeCategoryRank(String category) {
  final index = _typeCategoryOrder.indexOf(category);
  return index == -1 ? _typeCategoryOrder.length : index;
}

List<DeckCardGroup> sortGroups(List<DeckCardGroup> groups, SortMode mode) {
  final sorted = [...groups];
  switch (mode) {
    case SortMode.alphabetical:
      sorted.sort((a, b) => a.definition.name.compareTo(b.definition.name));
    case SortMode.byTypeAlpha:
      sorted.sort((a, b) {
        final catA = typeCategory(a.definition.typeLine);
        final catB = typeCategory(b.definition.typeLine);
        final rankCmp = _typeCategoryRank(catA).compareTo(_typeCategoryRank(catB));
        if (rankCmp != 0) return rankCmp;
        final catCmp = catA.compareTo(catB);
        if (catCmp != 0) return catCmp;
        return a.definition.name.compareTo(b.definition.name);
      });
    case SortMode.byTypeCmc:
      sorted.sort((a, b) {
        final catA = typeCategory(a.definition.typeLine);
        final catB = typeCategory(b.definition.typeLine);
        final rankCmp = _typeCategoryRank(catA).compareTo(_typeCategoryRank(catB));
        if (rankCmp != 0) return rankCmp;
        final catCmp = catA.compareTo(catB);
        if (catCmp != 0) return catCmp;
        final cmcCmp = (a.definition.cmc ?? 0).compareTo(b.definition.cmc ?? 0);
        if (cmcCmp != 0) return cmcCmp;
        return a.definition.name.compareTo(b.definition.name);
      });
  }
  return sorted;
}

/// Baut die Listeneinträge inkl. Zwischenüberschriften für Typ-Sortierung.
/// Strings sind Überschriften, [DeckCardGroup]s sind Karten-Einträge.
List<Object> buildSortedListItems(List<DeckCardGroup> groups, SortMode mode) {
  final sorted = sortGroups(groups, mode);
  if (!mode.isByType) return sorted;

  final items = <Object>[];
  String? currentCategory;
  for (final group in sorted) {
    final category = typeCategory(group.definition.typeLine);
    if (category != currentCategory) {
      items.add(category.isEmpty ? '—' : category);
      currentCategory = category;
    }
    items.add(group);
  }
  return items;
}

class PlayScreen extends ConsumerWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final activeDeckId = ref.watch(activeDeckProvider);

    if (activeDeckId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.navPlay)),
        body: _NoActiveDeck(l10n: l10n),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.navPlay),
          actions: [
            const LocaleToggleButton(),
            IconButton(
              icon: const Icon(Icons.replay),
              tooltip: l10n.roundReset,
              onPressed: () => _resetRound(context, ref, activeDeckId),
            ),
            PopupMenuButton<SortMode>(
              icon: const Icon(Icons.sort),
              tooltip: l10n.sortTooltip,
              initialValue: ref.watch(sortModeProvider),
              onSelected: (mode) =>
                  ref.read(sortModeProvider.notifier).set(mode),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: SortMode.alphabetical,
                  child: Text(l10n.sortAlphabetical),
                ),
                PopupMenuItem(
                  value: SortMode.byTypeCmc,
                  child: Text(l10n.sortByTypeCmc),
                ),
                PopupMenuItem(
                  value: SortMode.byTypeAlpha,
                  child: Text(l10n.sortByTypeAlpha),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.cloud_download_outlined),
              tooltip: l10n.enrichFromScryfall,
              onPressed: () => _enrichDeck(context, ref, activeDeckId),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.tabDeck),
              Tab(text: l10n.tabInPlay),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _DeckTab(deckId: activeDeckId),
            _InPlayTab(deckId: activeDeckId),
          ],
        ),
      ),
    );
  }

  Future<void> _resetRound(
    BuildContext context,
    WidgetRef ref,
    int deckId,
  ) async {
    final l10n = AppL10n.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.roundReset),
        content: Text(l10n.roundResetConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.roundReset),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(deckRepositoryProvider).resetAllInPlay(deckId);
  }

  Future<void> _enrichDeck(
    BuildContext context,
    WidgetRef ref,
    int deckId,
  ) async {
    final l10n = AppL10n.of(context);
    try {
      final repo = ref.read(deckRepositoryProvider);
      final count = await repo.enrichDeckFromScryfall(deckId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enrichSuccess(count))),
      );

      // Parse card text for cards without effects and show review screen
      final definitions = await repo.getCardDefinitionsForDeck(deckId);
      final learnedRules = await repo.getAllLearnedRules();
      final suggestions = <(CardDefinition, ParsedEffect)>[];
      for (final def in definitions) {
        if (def.oracleText == null) continue;
        if (await repo.hasEffects(def.id)) continue;
        for (final effect in CardTextParser.parse(def.oracleText!, cardName: def.name, learnedRules: learnedRules)) {
          suggestions.add((def, effect));
        }
      }

      // Second pass: auto-insert continuousEffect entries for ALL cards,
      // even those that already have other effects, skipping duplicates.
      for (final def in definitions) {
        if (def.oracleText == null) continue;
        final allEffects = CardTextParser.parse(def.oracleText!, cardName: def.name, learnedRules: learnedRules);
        for (final effect in allEffects) {
          if (effect.trigger != TriggerType.continuousEffect) continue;
          final alreadyPresent = await repo.hasContinuousEffectForDescription(def.id, effect.description);
          if (alreadyPresent) continue;
          await repo.addEffect(
            def.id,
            effect.trigger,
            effect.shortLabel,
            effect.shortLabelEn,
            effect.description,
            triggerConditionText: effect.triggerConditionText,
          );
        }
      }

      if (suggestions.isEmpty || !context.mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => EffectSuggestionScreen(suggestions: suggestions),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enrichFailed(e.toString()))),
      );
    }
  }
}

class _NoActiveDeck extends ConsumerWidget {
  const _NoActiveDeck({required this.l10n});

  final AppL10n l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decks = ref.watch(decksProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.noActiveDeck, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(l10n.selectDeckHint, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            decks.when(
              data: (decks) => Column(
                children: [
                  for (final deck in decks)
                    OutlinedButton(
                      onPressed: () => ref
                          .read(activeDeckProvider.notifier)
                          .state = deck.id,
                      child: Text(deck.name),
                    ),
                ],
              ),
              error: (e, _) => Text('Error: $e'),
              loading: () => const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeckTab extends ConsumerStatefulWidget {
  const _DeckTab({required this.deckId});

  final int deckId;

  @override
  ConsumerState<_DeckTab> createState() => _DeckTabState();
}

class _DeckTabState extends ConsumerState<_DeckTab> {
  final _scrollController = ScrollController();
  final _typeKeys = <String, GlobalKey>{};

  GlobalKey _keyForType(String category) =>
      _typeKeys.putIfAbsent(category, () => GlobalKey());

  void _scrollToType(String category) {
    final ctx = _keyForType(category).currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final groups = ref.watch(groupedCardsForDeckProvider(widget.deckId));
    final sortMode = ref.watch(sortModeProvider);
    final attachments =
        ref.watch(attachmentsForDeckProvider(widget.deckId)).valueOrNull ?? {};

    return groups.when(
      data: (allGroups) {
        final groups = allGroups.where((g) => g.board == 'main').toList();
        if (groups.isEmpty) {
          return Center(child: Text(l10n.cardsEmpty));
        }
        final items = buildSortedListItems(groups, sortMode);
        final typeCategories = sortMode.isByType
            ? items.whereType<String>().toList()
            : <String>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Typ-Navigations-Chips (nur bei Sortierung "nach Typ")
            if (typeCategories.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    for (int i = 0; i < typeCategories.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Expanded(
                        child: Tooltip(
                          message: _localizeCategory(typeCategories[i], l10n),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 36),
                            ),
                            onPressed: () => _scrollToType(typeCategories[i]),
                            child: Icon(_typeIcon(typeCategories[i])),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            // Kartenliste
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    for (final item in items)
                      if (item is String) ...[
                        SizedBox(key: _keyForType(item), height: 0),
                        _TypeHeader(title: item),
                      ]
                      else
                        Builder(
                          builder: (context) {
                            final group = item as DeckCardGroup;
                            final typeLine = group.definition.typeLine ?? '';
                            final isSpell = typeLine.contains('Instant') ||
                                typeLine.contains('Sorcery');
                            final showEquipSub =
                                isEquipmentOrAura(group.definition) &&
                                    group.inPlayCount > 0;
                            return ListTile(
                              contentPadding: const EdgeInsets.only(left: 16, right: 8),
                              leading: _EffectIndicator(
                                  cardDefinitionId: group.definition.id),
                              title: _cardTitleWidget(context, group.definition),
                              subtitle: showEquipSub
                                  ? _EquipmentSubtitle(
                                      deckId: widget.deckId,
                                      equipmentDefId: group.definition.id,
                                      attachments: attachments,
                                    )
                                  : null,
                              onTap: () => showCardInfoSheet(
                                  context, group.definition,
                                  deckId: widget.deckId),
                              trailing: isSpell
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${group.total}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.style),
                                          tooltip: l10n.castSpell,
                                          onPressed: () =>
                                              showCastSpellEffectsSheet(
                                                  context, group.definition),
                                        ),
                                      ],
                                    )
                                  : _InPlayStepper(
                                      group: group,
                                      deckId: widget.deckId,
                                      showRemove: false),
                            );
                          },
                        ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      error: (e, _) => Center(child: Text('Error: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

/// "(3)" für ganze CMC-Werte, "(3.5)" für nicht-ganzzahlige. Leerer String
/// wenn [cmc] null ist.
String _formatCmc(double? cmc) {
  if (cmc == null) return '';
  final isWhole = cmc == cmc.truncateToDouble();
  return '(${isWhole ? cmc.toInt() : cmc})';
}

/// "4" oder "4.5" als Text. "–" wenn [rating] null ist.
String _formatRating(double? rating) {
  if (rating == null) return '–';
  final isWhole = rating == rating.truncateToDouble();
  return isWhole ? rating.toInt().toString() : rating.toString();
}

/// Titelzeile: Kartenname + optionale Sternebewertung (kleiner, mit ★).
/// Darunter: (CMC) Typenzeile in gedimmter Schrift.
Widget _cardTitleWidget(BuildContext context, CardDefinition definition) {
  final isDe = Localizations.localeOf(context).languageCode == 'de';
  final displayName = isDe
      ? (definition.printedName ?? definition.name)
      : definition.name;
  final displayTypeLine = isDe
      ? (definition.printedTypeLine ?? definition.typeLine)
      : definition.typeLine;

  final cmcText = _formatCmc(definition.cmc);
  final hasTypeLine = displayTypeLine != null;
  final subtitleText = [
    if (cmcText.isNotEmpty) cmcText,
    if (hasTypeLine) displayTypeLine,
  ].join(' ');

  final theme = Theme.of(context);
  final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
    color: theme.colorScheme.onSurfaceVariant,
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      // Titelzeile: Name + Bewertung
      Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Flexible(child: Text(displayName)),
          if (definition.rating != null) ...[
            const SizedBox(width: 6),
            Text(
              '${_formatRating(definition.rating)} ★',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
      // Typ-Zeile: (CMC) Typ
      if (subtitleText.isNotEmpty)
        Text(subtitleText, style: subtitleStyle),
    ],
  );
}

/// Übersetzt den englischen Kategorienamen in die aktuelle Sprache.
String _localizeCategory(String category, AppL10n l10n) => switch (category) {
      'Creature' => l10n.cardTypeCreature,
      'Artifact' => l10n.cardTypeArtifact,
      'Instant' => l10n.cardTypeInstant,
      'Sorcery' => l10n.cardTypeSorcery,
      'Land' => l10n.cardTypeLand,
      'Enchantment' => l10n.cardTypeEnchantment,
      'Planeswalker' => l10n.cardTypePlaneswalker,
      _ => category,
    };

/// Liefert das passende Material-Icon für einen MTG-Kartentyp.
IconData _typeIcon(String category) => switch (category) {
      'Creature' => Icons.pets,
      'Artifact' => Icons.diamond,
      'Instant' => Icons.bolt,
      'Sorcery' => Icons.auto_fix_high,
      'Enchantment' => Icons.auto_awesome,
      'Land' => Icons.landscape,
      'Planeswalker' => Icons.face,
      _ => Icons.category,
    };

/// Zwischenüberschrift für eine Typ-Kategorie bei Sortierung "nach Typ".
class _TypeHeader extends StatelessWidget {
  const _TypeHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    final l10n = AppL10n.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Icon(_typeIcon(title), size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            _localizeCategory(title, l10n),
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Zeigt ein Blitz-Icon, wenn für die Karte mind. ein Effekt erfasst ist.
class _EffectIndicator extends ConsumerWidget {
  const _EffectIndicator({required this.cardDefinitionId});

  final int cardDefinitionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final effects = ref.watch(
      effectsForCardDefinitionProvider(cardDefinitionId),
    );
    // spellResolved beschreibt nur den eigenen Effekt eines Instant/Sorcery
    // beim Auflösen, kein Trigger, der während des Spiels "lauert" – daher
    // hier nicht als Trigger-Icon anzeigen.
    final entries = (effects.valueOrNull ?? const [])
        .where((e) => e.trigger != TriggerType.spellResolved.name)
        .toList();
    if (entries.isEmpty) return const SizedBox(width: 20);

    final styles = <TriggerStyle>{};
    for (final effect in entries) {
      final trigger = TriggerType.values.firstWhere(
        (t) => t.name == effect.trigger,
        orElse: () => TriggerType.castSpell,
      );
      styles.add(triggerStyle(trigger));
    }

    return SizedBox(
      width: 20,
      child: Wrap(
        spacing: 2,
        runSpacing: 2,
        children: [
          for (final style in styles)
            Icon(
              style.icon,
              color: style.color,
              size: 20,
              semanticLabel: l10n.cardHasEffects,
            ),
        ],
      ),
    );
  }
}

class _InPlayStepper extends ConsumerWidget {
  const _InPlayStepper({
    required this.group,
    required this.deckId,
    this.showAdd = true,
    this.showRemove = true,
  });

  final DeckCardGroup group;
  final int deckId;
  final bool showAdd;
  final bool showRemove;

  Future<void> _handleAdd(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(deckRepositoryProvider);
    final newCount = group.inPlayCount + 1;
    await repo.setInPlayCount(group, newCount);
    // Equipment/Aura zum ersten Mal ins Spiel: Ziel abfragen
    if (newCount == 1 &&
        isEquipmentOrAura(group.definition) &&
        context.mounted) {
      final target =
          await showEquipmentPicker(context, deckId, group.definition, ref);
      if (!context.mounted) return;
      if (target != null) {
        await repo.attachEquipment(deckId, group.definition.id, target.id);
      }
    }
  }

  Future<void> _handleRemove(WidgetRef ref) async {
    final repo = ref.read(deckRepositoryProvider);
    final newCount = group.inPlayCount - 1;
    await repo.setInPlayCount(group, newCount);
    if (newCount == 0 && isEquipmentOrAura(group.definition)) {
      await repo.detachEquipment(deckId, group.definition.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${group.inPlayCount} / ${group.total}'),
        if (showRemove)
          IconButton(
            icon: const Icon(Symbols.computer_cancel),
            onPressed: group.inPlayCount > 0
                ? () => _handleRemove(ref)
                : null,
          ),
        if (showAdd)
          IconButton(
            icon: const Icon(Icons.style),
            onPressed: group.inPlayCount < group.total
                ? () => _handleAdd(context, ref)
                : null,
          ),
      ],
    );
  }
}

/// Kompakter Sprach-Toggle-Button für AppBars.
/// Wechselt zwischen DE und EN; zeigt jeweils die *andere* Sprache als Label.
class LocaleToggleButton extends ConsumerWidget {
  const LocaleToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final effectiveCode =
        locale?.languageCode ?? Localizations.localeOf(context).languageCode;
    final isDE = effectiveCode == 'de';
    return TextButton(
      onPressed: () {
        ref.read(localeProvider.notifier).state =
            isDE ? const Locale('en') : const Locale('de');
      },
      child: Text(
        isDE ? 'EN' : 'DE',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _InPlayTab extends ConsumerWidget {
  const _InPlayTab({required this.deckId});

  final int deckId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final groups = ref.watch(groupedCardsForDeckProvider(deckId));
    final sortMode = ref.watch(sortModeProvider);

    return groups.when(
      data: (allGroups) {
        final inPlay = allGroups
            .where((g) => g.board == 'main' && g.inPlayCount > 0)
            .toList();
        if (inPlay.isEmpty) {
          return Center(child: Text(l10n.inPlayEmpty));
        }
        final items = buildSortedListItems(inPlay, sortMode);
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            if (item is String) {
              return _TypeHeader(title: item);
            }
            final group = item as DeckCardGroup;
            return ListTile(
              contentPadding: const EdgeInsets.only(left: 16, right: 8),
              leading: _EffectIndicator(cardDefinitionId: group.definition.id),
              title: _cardTitleWidget(context, group.definition),
              onTap: () =>
                  showCardInfoSheet(context, group.definition, deckId: deckId),
              trailing: _InPlayStepper(
                  group: group, deckId: deckId, showAdd: false),
            );
          },
        );
      },
      error: (e, _) => Center(child: Text('Error: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _EquipmentSubtitle extends ConsumerWidget {
  const _EquipmentSubtitle({
    required this.deckId,
    required this.equipmentDefId,
    required this.attachments,
  });

  final int deckId;
  final int equipmentDefId;
  final Map<int, int> attachments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final isDe = Localizations.localeOf(context).languageCode == 'de';
    final targetId = attachments[equipmentDefId];
    if (targetId == null) {
      return Text(
        l10n.equipmentNotAttached,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.outlineVariant,
          fontStyle: FontStyle.italic,
        ),
      );
    }
    final allGroups =
        ref.watch(groupedCardsForDeckProvider(deckId)).valueOrNull;
    final targetDef = allGroups
        ?.where((g) => g.definition.id == targetId)
        .map((g) => g.definition)
        .firstOrNull;
    final targetName = targetDef == null
        ? '...'
        : (isDe ? (targetDef.printedName ?? targetDef.name) : targetDef.name);
    return Text(
      l10n.equipmentAttachedTo(targetName),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
