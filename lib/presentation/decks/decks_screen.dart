import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/import/deck_list_parser.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/active_deck_provider.dart';
import '../../providers/deck_providers.dart';

class DecksScreen extends ConsumerWidget {
  const DecksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final decks = ref.watch(decksProvider);
    final activeDeckId = ref.watch(activeDeckProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.decksTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            tooltip: l10n.importDeck,
            onPressed: () => _importDeck(context, ref),
          ),
        ],
      ),
      body: decks.when(
        data: (decks) {
          if (decks.isEmpty) {
            return Center(child: Text(l10n.decksEmpty));
          }
          return ListView.builder(
            itemCount: decks.length,
            itemBuilder: (context, index) {
              final deck = decks[index];
              final isActive = deck.id == activeDeckId;
              return ListTile(
                leading: Icon(
                  isActive ? Icons.radio_button_checked : Icons.radio_button_off,
                ),
                title: Text(deck.name),
                subtitle: isActive ? Text(l10n.activeDeck) : null,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () =>
                      ref.read(deckRepositoryProvider).deleteDeck(deck.id),
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

  Future<void> _importDeck(BuildContext context, WidgetRef ref) async {
    final l10n = AppL10n.of(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.single;
      final content = file.bytes != null
          ? String.fromCharCodes(file.bytes!)
          : await File(file.path!).readAsString();

      final cards = parseDeckList(content);
      if (cards.isEmpty) {
        throw Exception(l10n.importEmptyError);
      }

      final deckName = file.name.replaceAll(RegExp(r'\.txt$'), '');
      final deckId = await ref
          .read(deckRepositoryProvider)
          .importDeckList(deckName, cards);
      ref.read(activeDeckProvider.notifier).state = deckId;

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.importSuccess(cards.length))),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.importFailed(e.toString()))),
      );
    }
  }
}
