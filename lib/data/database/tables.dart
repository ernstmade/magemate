import 'package:drift/drift.dart';

// Hinweis zur Schema-Evolution: Neue Spalten möglichst `.nullable()` oder mit
// `.withDefault(...)` anlegen, damit spätere Migrationen einfach bleiben.

// ─── Deck ────────────────────────────────────────────────────────────────────

class Decks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// ─── Card-Definition (abstrakte Karte) ──────────────────────────────────────

// Eigenschaften einer Karte als solche (Scryfall-Daten, Oracle-Text), losgelöst
// davon, in welchem Deck/wie oft sie vorkommt. CardEffects hängen hier.
class CardDefinitions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get setCode => text().nullable()();
  TextColumn get collectorNumber => text().nullable()();
  TextColumn get scryfallId => text().nullable()();
  TextColumn get manaCost => text().nullable()();
  RealColumn get cmc => real().nullable()();
  TextColumn get typeLine => text().nullable()();
  TextColumn get oracleText => text().nullable()();
  // kommagetrennt, z.B. "R" oder "U,B"
  TextColumn get colors => text().nullable()();
  // als Text wegen Werten wie "*" oder "1+*"
  TextColumn get power => text().nullable()();
  TextColumn get toughness => text().nullable()();
  TextColumn get imageUri => text().nullable()();
}

// ─── Deck-Karte (konkretes Exemplar im Deck) ────────────────────────────────

// Eine Zeile pro physischem Exemplar. 4x Lightning Bolt = 4 Zeilen, jede mit
// eigenem `inPlay`-Status.
class DeckCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get deckId => integer().references(Decks, #id)();
  IntColumn get cardDefinitionId => integer().references(CardDefinitions, #id)();
  // 'main' | 'side' | 'maybe'
  TextColumn get board => text().withDefault(const Constant('main'))();
  // Aktuell im Spiel befindlich (für die Trigger-Auswertung)
  BoolColumn get inPlay => boolean().withDefault(const Constant(false))();
}

// ─── Card-Effekt ─────────────────────────────────────────────────────────────

// Ein Effekt einer Karten-Definition, ausgelöst durch einen TriggerType.
// `trigger` speichert den Enum-Namen von TriggerType (z.B. "dies").
class CardEffects extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardDefinitionId =>
      integer().references(CardDefinitions, #id)();
  TextColumn get trigger => text()();
  // Nur relevant bei trigger == castSpell: SpellCategory-Enum-Name, also
  // ob der Effekt auf jeden Nicht-Kreatur-Spruch oder nur Instant/Sorcery
  // reagiert.
  TextColumn get spellCategory => text().nullable()();
  // Kurzschreibweise für die schnelle Übersicht, z.B. "3 Schaden an alle".
  TextColumn get shortLabel => text().withDefault(const Constant(''))();
  TextColumn get description => text()();
  // Optionaler Bezug auf einen anderen Effekt, der durch diesen Effekt
  // beeinflusst/ausgelöst wird (für Effekt-Verkettungen).
  IntColumn get triggersEffectId =>
      integer().nullable().references(CardEffects, #id)();
}
