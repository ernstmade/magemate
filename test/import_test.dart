import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magicsupport/data/database/app_database.dart';
import 'package:magicsupport/data/import/deck_list_parser.dart';
import 'package:magicsupport/providers/deck_providers.dart';

void main() {
  test('Deck-Import legt DeckCards an, die im Deck-Tab sichtbar sind', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = DeckRepository(db);

    final content = await File(
      'Damage Damage! V9.txt',
    ).readAsString();
    final cards = parseDeckList(content);
    final deckId = await repo.importDeckList('Damage Damage! V9', cards);

    final rows = await (db.select(db.deckCards).join([
      drift.innerJoin(
        db.cardDefinitions,
        db.cardDefinitions.id.equalsExp(db.deckCards.cardDefinitionId),
      ),
    ])..where(db.deckCards.deckId.equals(deckId)))
        .get();

    expect(rows.length, cards.fold<int>(0, (sum, c) => sum + c.quantity));

    final byBoard = <String, int>{};
    for (final r in rows) {
      final board = r.readTable(db.deckCards).board;
      byBoard[board] = (byBoard[board] ?? 0) + 1;
    }
    expect(byBoard, {'main': 60, 'side': 24, 'maybe': 29});
    await db.close();
  });
}
