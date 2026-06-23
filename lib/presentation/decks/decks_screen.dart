import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/active_deck_provider.dart';
import '../../providers/deck_providers.dart';
import 'deck_analysis_screen.dart';
import 'deck_manage_screen.dart';
import 'new_deck_dialog.dart';

class DecksScreen extends ConsumerWidget {
  const DecksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final decks = ref.watch(decksProvider);
    final activeDeckId = ref.watch(activeDeckProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.decksTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _newDeck(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.newDeckTitle),
      ),
      body: decks.when(
        data: (decks) {
          if (decks.isEmpty) {
            return Center(child: Text(l10n.decksEmpty));
          }
          return ListView.builder(
            itemCount: decks.length,
            // Genug Platz für den FAB
            padding: const EdgeInsets.only(bottom: 88),
            itemBuilder: (context, index) {
              final deck = decks[index];
              final isActive = deck.id == activeDeckId;
              return ListTile(
                leading: Icon(
                  isActive ? Icons.radio_button_checked : Icons.radio_button_off,
                ),
                title: Text(deck.name),
                subtitle: isActive ? Text(l10n.activeDeck) : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.tune),
                      tooltip: l10n.manageDeck,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => DeckManageScreen(
                            deckId: deck.id,
                            deckName: deck.name,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () =>
                          ref.read(deckRepositoryProvider).deleteDeck(deck.id),
                    ),
                  ],
                ),
                onTap: () =>
                    ref.read(activeDeckProvider.notifier).state = deck.id,
              );
            },
          );
        },
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _newDeck(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<NewDeckResult>(
      context: context,
      builder: (_) => const NewDeckDialog(),
    );
    if (result == null || !context.mounted) return;

    final repo = ref.read(deckRepositoryProvider);

    if (result.cards == null) {
      // Manueller Pfad: leeres Deck erstellen
      final deckId = await repo.createDeck(result.name);
      ref.read(activeDeckProvider.notifier).state = deckId;
    } else {
      // Import-Pfad: Deck importieren, dann zur Analyse navigieren
      final deckId = await repo.importDeckList(result.name, result.cards!);
      ref.read(activeDeckProvider.notifier).state = deckId;
      if (!context.mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => DeckAnalysisScreen(
            deckId: deckId,
            deckName: result.name,
            importedCards: result.cards!,
          ),
        ),
      );
    }
  }
}
