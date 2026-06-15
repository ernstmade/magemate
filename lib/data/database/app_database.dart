import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Decks, CardDefinitions, DeckCards, CardEffects])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openDatabase());

  /// Für Tests: erlaubt die Übergabe eines eigenen [QueryExecutor]
  /// (z.B. `NativeDatabase.memory()`).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Frühe Entwicklungsversion: `cards`/`card_effects` durch das neue
        // Modell (CardDefinitions + DeckCards) ersetzt. Keine Bestandsdaten
        // zu erhalten.
        await customStatement('DROP TABLE IF EXISTS cards');
        await customStatement('DROP TABLE IF EXISTS card_effects');
        await m.createTable(cardDefinitions);
        await m.createTable(deckCards);
        await m.createTable(cardEffects);
      }
      if (from < 3) {
        await m.addColumn(cardEffects, cardEffects.shortLabel);
      }
      if (from < 4) {
        await m.addColumn(cardEffects, cardEffects.spellCategory);
      }
    },
  );
}

QueryExecutor _openDatabase() {
  return driftDatabase(name: 'magicsupport');
}
