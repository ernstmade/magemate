import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/active_deck_provider.dart';
import '../../providers/deck_providers.dart';
import '../../shared/models/trigger_style.dart';
import '../../shared/models/trigger_type.dart';
import 'card_info_sheet.dart';
import 'cast_spell_sheet.dart';

/// Sortieroptionen für die Kartenlisten in "Deck" und "Im Spiel".
enum SortMode { alphabetical, byType }

final sortModeProvider = StateProvider<SortMode>((ref) => SortMode.alphabetical);

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
    case SortMode.byType:
      sorted.sort((a, b) {
        final categoryA = typeCategory(a.definition.typeLine);
        final categoryB = typeCategory(b.definition.typeLine);
        final rankCompare = _typeCategoryRank(
          categoryA,
        ).compareTo(_typeCategoryRank(categoryB));
        if (rankCompare != 0) return rankCompare;
        final categoryCompare = categoryA.compareTo(categoryB);
        if (categoryCompare != 0) return categoryCompare;
        return a.definition.name.compareTo(b.definition.name);
      });
  }
  return sorted;
}

/// Baut die Listeneinträge inkl. Zwischenüberschriften für [SortMode.byType].
/// Strings sind Überschriften, [DeckCardGroup]s sind Karten-Einträge.
List<Object> buildSortedListItems(List<DeckCardGroup> groups, SortMode mode) {
  final sorted = sortGroups(groups, mode);
  if (mode != SortMode.byType) return sorted;

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
            PopupMenuButton<SortMode>(
              icon: const Icon(Icons.sort),
              tooltip: l10n.sortTooltip,
              initialValue: ref.watch(sortModeProvider),
              onSelected: (mode) =>
                  ref.read(sortModeProvider.notifier).state = mode,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: SortMode.alphabetical,
                  child: Text(l10n.sortAlphabetical),
                ),
                PopupMenuItem(
                  value: SortMode.byType,
                  child: Text(l10n.sortByType),
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

  Future<void> _enrichDeck(
    BuildContext context,
    WidgetRef ref,
    int deckId,
  ) async {
    final l10n = AppL10n.of(context);
    try {
      final count = await ref
          .read(deckRepositoryProvider)
          .enrichDeckFromScryfall(deckId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enrichSuccess(count))),
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

class _DeckTab extends ConsumerWidget {
  const _DeckTab({required this.deckId});

  final int deckId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final groups = ref.watch(groupedCardsForDeckProvider(deckId));
    final sortMode = ref.watch(sortModeProvider);

    return groups.when(
      data: (groups) {
        if (groups.isEmpty) {
          return Center(child: Text(l10n.cardsEmpty));
        }
        final items = buildSortedListItems(groups, sortMode);
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            if (item is String) {
              return _TypeHeader(title: item);
            }
            final group = item as DeckCardGroup;
            final typeLine = group.definition.typeLine ?? '';
            final isSpell =
                typeLine.contains('Instant') || typeLine.contains('Sorcery');
            return ListTile(
              leading: _EffectIndicator(cardDefinitionId: group.definition.id),
              title: Text(group.definition.name),
              subtitle: group.definition.typeLine != null
                  ? Text(group.definition.typeLine!)
                  : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    tooltip: l10n.cardInfo,
                    onPressed: () =>
                        showCardInfoSheet(context, group.definition),
                  ),
                  if (isSpell)
                    IconButton(
                      icon: Icon(
                        triggerStyle(TriggerType.castSpell).icon,
                        color: triggerStyle(TriggerType.castSpell).color,
                      ),
                      tooltip: l10n.castSpell,
                      onPressed: () => showCastSpellEffectsSheet(context),
                    )
                  else
                    _InPlayStepper(group: group),
                ],
              ),
            );
          },
        );
      },
      error: (e, _) => Center(child: Text('Error: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

/// Zwischenüberschrift für eine Typ-Kategorie bei Sortierung "nach Typ".
class _TypeHeader extends StatelessWidget {
  const _TypeHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
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
    final entries = effects.valueOrNull ?? const [];
    if (entries.isEmpty) return const SizedBox(width: 32);

    final styles = <TriggerStyle>{};
    for (final effect in entries) {
      final trigger = TriggerType.values.firstWhere(
        (t) => t.name == effect.trigger,
        orElse: () => TriggerType.castSpell,
      );
      styles.add(triggerStyle(trigger));
    }

    return SizedBox(
      width: 32,
      child: Wrap(
        spacing: 2,
        runSpacing: 2,
        children: [
          for (final style in styles)
            Icon(
              style.icon,
              color: style.color,
              size: 16,
              semanticLabel: l10n.cardHasEffects,
            ),
        ],
      ),
    );
  }
}

class _InPlayStepper extends ConsumerWidget {
  const _InPlayStepper({required this.group});

  final DeckCardGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(deckRepositoryProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: group.inPlayCount > 0
              ? () => repo.setInPlayCount(group, group.inPlayCount - 1)
              : null,
        ),
        Text('${group.inPlayCount} / ${group.total}'),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: group.inPlayCount < group.total
              ? () => repo.setInPlayCount(group, group.inPlayCount + 1)
              : null,
        ),
      ],
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
      data: (groups) {
        final inPlay = groups.where((g) => g.inPlayCount > 0).toList();
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
              leading: _EffectIndicator(cardDefinitionId: group.definition.id),
              title: Text(group.definition.name),
              subtitle: group.definition.typeLine != null
                  ? Text(group.definition.typeLine!)
                  : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    tooltip: l10n.cardInfo,
                    onPressed: () =>
                        showCardInfoSheet(context, group.definition),
                  ),
                  _InPlayStepper(group: group),
                ],
              ),
            );
          },
        );
      },
      error: (e, _) => Center(child: Text('Error: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
