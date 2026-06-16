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
  // Lokalisierter Kartenname (z.B. Deutsch), falls von Scryfall verfügbar.
  TextColumn get printedName => text().nullable()();
  // Lokalisierter Regeltext (z.B. Deutsch), falls von Scryfall verfügbar.
  TextColumn get printedText => text().nullable()();
  // Lokalisierter Typ (z.B. Deutsch), falls von Scryfall verfügbar.
  TextColumn get printedTypeLine => text().nullable()();
  // Persönliche Bewertung der Karte: 0–5,5 in 0,25-Schritten. Null = nicht bewertet.
  RealColumn get rating => real().nullable()();
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
  // Lvl3-Detail, abhängig vom Trigger-Typ (Lvl2):
  // - castSpell / spellDealsDamage: SpellCategory-Enum-Name
  //   (instantOrSorcery / noncreatureSpell)
  // - staticDamageModifier / dealsNoncombatDamage: SourceFilter-Enum-Name
  //   (redSource / anySource)
  // Spaltenname bleibt aus Migrationsgründen "spell_category".
  TextColumn get triggerDetail => text().nullable().named('spell_category')();
  // Kommagetrennte Liste von EffectCondition-Enum-Namen, z.B. "singleTarget".
  // Orthogonale Zusatzbedingungen, erweiterbar ohne neue Migration.
  TextColumn get extraConditions => text().nullable()();
  // Kurzschreibweise für die schnelle Übersicht (primäre Sprache, i.d.R. DE).
  TextColumn get shortLabel => text().withDefault(const Constant(''))();
  // Kurzschreibweise auf Englisch (Fallback wenn leer: shortLabel).
  TextColumn get shortLabelEn => text().nullable()();
  TextColumn get description => text()();
  // Fester Schadenswert dieses Effekts, falls vorhanden und numerisch fix
  // (z.B. 3 bei Lightning Bolt). Null bei variablem Schaden (z.B. "= Stärke")
  // oder wenn der Effekt keinen direkten Schaden verursacht.
  IntColumn get damageAmount => integer().nullable()();
  // Ziel des Schadens, DamageTarget-Enum-Name. Nur relevant, wenn
  // [damageAmount] gesetzt ist.
  TextColumn get damageTarget => text().nullable()();
  // Auf welche Ziele dieser Replacement-Effekt wirkt: ReplacementScope-Enum-Name.
  // null / "all"         → Gegner UND Kreaturen (z.B. Torbran)
  // "opponentOnly"       → Nur Gegner als Spieler (z.B. Ojer Axonil)
  // Nur relevant für staticDamageModifier.
  TextColumn get replacementScope => text().nullable()();
  // Wenn true: damageAmount wird nicht aus der DB gelesen, sondern zur Laufzeit
  // aus dem effektiven Spell-Schaden an die Zielkreatur abgeleitet (z.B. Imodane).
  // Nur relevant für spellDealsDamage.
  BoolColumn get dynamicDamage => boolean().nullable()();
  // Multiplikator für Replacement-Effekte (z.B. 2 für "doppelter Schaden von
  // roten Quellen" wie Fiendish Duo). Nur relevant für staticDamageModifier.
  // Additive (damageAmount) und Multiplikatoren werden getrennt gespeichert,
  // damit die Reihenfolge für maximalen Schaden korrekt angewendet werden kann:
  // erst addieren, dann multiplizieren.
  IntColumn get damageMultiplier => integer().nullable()();
  // Mindestwert für Replacement-Effekte (z.B. Ojer Axonil: Schaden einer roten
  // Quelle wird auf mindestens [power] angehoben, wenn er darunter liegt).
  // Für optimalen Schaden: zuerst floor anwenden, dann addieren, dann
  // multiplizieren.
  IntColumn get damageMinimum => integer().nullable()();
  // Optionaler Bezug auf einen anderen Effekt, der durch diesen Effekt
  // beeinflusst/ausgelöst wird (für Effekt-Verkettungen).
  IntColumn get triggersEffectId =>
      integer().nullable().references(CardEffects, #id)();
}
