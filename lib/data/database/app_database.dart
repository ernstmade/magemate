import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Decks, CardDefinitions, DeckCards, CardEffects])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openDatabase());

  /// Für Tests: erlaubt die Übergabe eines eigenen [QueryExecutor]
  /// (z.B. `NativeDatabase.memory()`).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 13;

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
        await m.addColumn(cardEffects, cardEffects.triggerDetail);
      }
      if (from < 5) {
        await m.addColumn(cardEffects, cardEffects.extraConditions);
      }
      if (from < 6) {
        await m.addColumn(cardEffects, cardEffects.damageAmount);
        await m.addColumn(cardEffects, cardEffects.damageTarget);
      }
      if (from < 7) {
        await m.addColumn(cardEffects, cardEffects.damageMultiplier);
      }
      if (from < 8) {
        await m.addColumn(cardEffects, cardEffects.damageMinimum);
      }
      if (from < 9) {
        await m.addColumn(cardEffects, cardEffects.replacementScope);
        await m.addColumn(cardEffects, cardEffects.dynamicDamage);
      }
      if (from < 10) {
        await m.addColumn(cardDefinitions, cardDefinitions.printedName);
        await m.addColumn(cardDefinitions, cardDefinitions.printedText);
        await m.addColumn(cardDefinitions, cardDefinitions.printedTypeLine);
      }
      if (from < 11) {
        await m.addColumn(cardEffects, cardEffects.shortLabelEn);
      }
      if (from < 12) {
        // EN-Kurztexte für bestehende Effekte nachpflegen.
        // Abgleich über den deutschen Kurztext (short_label), da IDs
        // geräteabhängig sind.
        final updates = <(String de, String en)>[
          ('3 Schaden an Kreatur oder Artefakt zerstören',           '3 dmg to creature or destroy artifact'),
          ('Flashback für Spontan/Hexerei',                          'Flashback for instant/sorcery'),
          ('3 Schaden an jeden Gegner',                              '3 damage to each opponent'),
          ('Schaden an einen Gegner deiner Wahl',                    'Damage to opponent of your choice'),
          ('+1/+1, Schaden an einen Gegner',                         '+1/+1, damage to an opponent'),
          ('Gleicher Schaden an Kreatur/PW',                         'Same damage to creature/PW'),
          ('1 Schaden an alle Gegner',                               '1 damage to each opponent'),
          ('1/1 Dwarf-Token',                                        '1/1 Dwarf token'),
          ('Wähle 3x: 1 Schaden an alle Kreaturen / 2 Schaden an jeden Gegner / Artefakt zerstören',
           'Choose 3×: 1 dmg all creatures / 2 dmg each opp / destroy artifact'),
          ('2 Schaden an alle Gegner',                               '2 damage to each opponent'),
          ('Gleicher Schaden an alle Gegner',                        'Same damage to each opponent'),
          ('1 Schaden an gegnerische Kreaturen oder 4 Schaden an eine Kreatur',
           '1 dmg opp creatures or 4 dmg one creature'),
          ('3 Schaden an ein beliebiges Ziel',                       '3 damage to any target'),
          ('Gegnerische Kreatur fügt einer anderen ihre Stärke als Schaden zu',
           "Opp's creature deals power as damage"),
          ('Transformiert zurück (Temple of Power)',                  'Transforms back (Temple of Power)'),
          ('Mindest-Schaden = Stärke',                               'Min. damage = power'),
          ('Gleicher Schaden an Kreatur des Gegners',                "Same damage to opp's creature"),
          ('Spieler wählen',                                         'Players choose'),
          ('Schaden an gewählten Spieler verdoppelt',                 'Damage to chosen player doubled'),
          ('2 Karten ziehen',                                        'Draw 2 cards'),
          ('Spruch kopieren + Wither',                               'Copy spell + Wither'),
          ('1 Schaden an Spieler/PW',                               '1 damage to player/PW'),
          ('3 Schaden an Kreatur (Exil bei Tod) oder Artefakt verbannen',
           '3 dmg to creature (exile on death) or exile artifact'),
          ('1 Schaden an jeden Gegner und deren Kreaturen',          '1 dmg to each opp and their creatures'),
          ('+2 Schaden von roten Quellen',                           '+2 from red sources'),
          ('3 Schaden an Kreatur/Planeswalker/Battle, optional Karte tauschen',
           '3 dmg to creature/PW/battle, opt. loot'),
        ];
        for (final (de, en) in updates) {
          await customStatement(
            'UPDATE card_effects SET short_label_en = ? WHERE short_label = ? AND (short_label_en IS NULL OR short_label_en = \'\')',
            [en, de],
          );
        }
        // Chandra's Incinerator: Zusatzbedingung damageToOpponent setzen –
        // triggert nur, wenn der Schaden an einen Gegner (Spieler) geht.
        await customStatement(
          "UPDATE card_effects SET extra_conditions = 'damageToOpponent' WHERE trigger = 'dealsNoncombatDamage' AND short_label = 'Gleicher Schaden an Kreatur/PW' AND (extra_conditions IS NULL OR extra_conditions = '')",
        );
        // Chandra's Incinerator: triggerDetail (spell_category) auf anySource setzen.
        // Null verhält sich zwar gleich (passt immer), aber explizit ist besser.
        await customStatement(
          "UPDATE card_effects SET spell_category = 'anySource' WHERE spell_category IS NULL AND trigger = 'dealsNoncombatDamage' AND short_label = 'Gleicher Schaden an Kreatur/PW'",
        );
      }
      if (from < 13) {
        await m.addColumn(cardDefinitions, cardDefinitions.rating);

        // Effekt-Datenkorrekturen: fehlende Schadenswerte, Scopes und Labels.
        // Abgleich über short_label, da IDs geräteabhängig sind.

        // Abrade: Schadenswert für Kreatur-Modus
        await customStatement(
          "UPDATE card_effects SET damage_amount=3, damage_target='singleCreature'"
          " WHERE short_label='3 Schaden an Kreatur oder Artefakt zerstören'",
        );
        // Caldera Pyremaw: Ziel für variablen Schaden
        await customStatement(
          "UPDATE card_effects SET damage_target='singleOpponent'"
          " WHERE short_label='+1/+1, Schaden an einen Gegner'",
        );
        // Satyr Firedancer: triggert nur bei Gegner-Schaden + Ziel = Kreatur
        await customStatement(
          "UPDATE card_effects SET extra_conditions='damageToOpponent', damage_target='singleCreature'"
          " WHERE short_label='Gleicher Schaden an Kreatur des Gegners'",
        );
        // Sawhorn Nemesis: Multiplikator ×2 und Scope fehlten
        await customStatement(
          "UPDATE card_effects SET damage_multiplier=2, replacement_scope='all'"
          " WHERE short_label='Schaden an gewählten Spieler verdoppelt'",
        );
        // Sunscorched Desert: Schadenswert + Ziel
        await customStatement(
          "UPDATE card_effects SET damage_amount=1, damage_target='singleOpponent'"
          " WHERE short_label='1 Schaden an Spieler/PW'",
        );
        // Suplex: Schadenswert + Ziel
        await customStatement(
          "UPDATE card_effects SET damage_amount=3, damage_target='singleCreature'"
          " WHERE short_label='3 Schaden an Kreatur (Exil bei Tod) oder Artefakt verbannen'",
        );
        // Tectonic Hazard: Labels der zwei Effekte trennen
        await customStatement(
          "UPDATE card_effects SET short_label='1 Schaden an jeden Gegner',"
          " short_label_en='1 dmg to each opponent'"
          " WHERE damage_target='eachOpponent' AND card_definition_id IN"
          "   (SELECT id FROM card_definitions WHERE name='Tectonic Hazard')",
        );
        await customStatement(
          "UPDATE card_effects SET short_label='1 Schaden an Kreaturen der Gegner',"
          " short_label_en='1 dmg to opp creatures'"
          " WHERE damage_target='eachOpponentCreatures' AND card_definition_id IN"
          "   (SELECT id FROM card_definitions WHERE name='Tectonic Hazard')",
        );
        // Tunneling Geopede: Landfall-Effekt fehlte komplett
        await customStatement(
          "INSERT OR IGNORE INTO card_effects"
          " (card_definition_id, trigger, damage_amount, damage_target, short_label, short_label_en, description)"
          " SELECT id, 'landfall', 1, 'eachOpponent',"
          "   '1 Schaden an alle Gegner', '1 damage to each opponent',"
          "   'Landfall — Whenever a land you control enters, this creature deals 1 damage to each opponent.'"
          " FROM card_definitions WHERE name='Tunneling Geopede'"
          "   AND NOT EXISTS (SELECT 1 FROM card_effects WHERE trigger='landfall'"
          "     AND card_definition_id = (SELECT id FROM card_definitions WHERE name='Tunneling Geopede'))",
        );
      }
    },
  );
}

/// Öffnet die Datenbank. Beim ersten Start (Datei fehlt) wird die mitgelieferte
/// Seed-DB aus den App-Assets in den Dokumentenordner kopiert, sodass das
/// "Damage Damage!"-Deck bereits vorgeladen ist. Spätere Starts nutzen die
/// Gerätekopie inklusive aller Nutzeränderungen.
QueryExecutor _openDatabase() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'magemate.sqlite'));

    if (!file.existsSync()) {
      final blob = await rootBundle.load('assets/magemate.sqlite');
      await file.writeAsBytes(
        blob.buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes),
      );
    }

    return NativeDatabase(file);
  });
}
