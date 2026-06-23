import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Decks, CardDefinitions, DeckCards, CardEffects, LearnedRules, CardAttachments])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openDatabase());

  /// Für Tests: erlaubt die Übergabe eines eigenen [QueryExecutor]
  /// (z.B. `NativeDatabase.memory()`).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 23;

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
      if (from < 14) {
        await m.createTable(learnedRules);
      }
      if (from < 15) {
        await m.addColumn(cardDefinitions, cardDefinitions.keywords);
      }
      if (from < 16) {
        await m.addColumn(cardEffects, cardEffects.triggerConditionText);
        await m.addColumn(learnedRules, learnedRules.triggerConditionText);
      }
      if (from < 17) {
        // Steelhammer Fantasy Main-Deck: Effekte und Dauereffekte einpflegen.
        // (cardName, trigger, shortLabelDe, shortLabelEn, description, triggerConditionText)
        const effects = <(String, String, String, String, String, String?)>[
          ('Ardenn, Intrepid Archaeologist', 'beginningOfCombat',
            'Ausrüstungen/Auren anlegen', 'Attach Equipment/Auras',
            'At the beginning of combat on your turn, you may attach any number of Auras and Equipment you control to target permanent or player.',
            null),
          ('Argentum Armor', 'continuousEffect',
            '+6/+6', '+6/+6',
            'Equipped creature gets +6/+6.',
            null),
          ('Argentum Armor', 'attacks',
            'Permanent zerstören', 'Destroy target permanent',
            'Whenever equipped creature attacks, destroy target permanent.',
            null),
          ('Armored Skyhunter', 'attacks',
            'Top 6: Aura/Ausrüstung ins Spiel anlegen', 'Top 6: put Aura/Equipment into play',
            'Whenever this creature attacks, look at the top six cards of your library. You may put an Aura or Equipment card from among them onto the battlefield. If an Equipment is put onto the battlefield this way, you may attach it to a creature you control. Put the rest of those cards on the bottom of your library in a random order.',
            null),
          ('Armory Automaton', 'attacks',
            'Beliebig viele Ausrüstungen anlegen', 'Attach any number of Equipment',
            'Whenever this creature enters or attacks, you may attach any number of target Equipment to it.',
            null),
          ('Barret, Avalanche Leader', 'enterBattlefield',
            '2/2 Rebel Token erstellen', 'Create 2/2 Rebel token',
            'Whenever an Equipment you control enters, create a 2/2 red Rebel creature token.',
            null),
          ('Barret, Avalanche Leader', 'beginningOfCombat',
            'Ausrüstung an Rebellen anlegen', 'Attach Equipment to Rebel',
            'At the beginning of combat on your turn, attach up to one target Equipment you control to target Rebel you control.',
            null),
          ('Basilisk Collar', 'continuousEffect',
            'Todesberührung + Lebensband', 'Deathtouch + lifelink',
            'Equipped creature has deathtouch and lifelink.',
            null),
          ('Blazing Sunsteel', 'continuousEffect',
            '+1/+0 pro Gegner', '+1/+0 per opponent',
            'Equipped creature gets +1/+0 for each opponent you have.',
            null),
          ('Blazing Sunsteel', 'takesDamage',
            'Gleicher Schaden an beliebiges Ziel', 'Same damage to any target',
            'Whenever equipped creature is dealt damage, it deals that much damage to any target.',
            null),
          ('Bloodforged Battle-Axe', 'continuousEffect',
            '+2/+0', '+2/+0',
            'Equipped creature gets +2/+0.',
            null),
          ('Bloodforged Battle-Axe', 'dealsCombatDamage',
            'Token-Kopie erstellen', 'Create token copy',
            "Whenever equipped creature deals combat damage to a player, create a token that's a copy of this Equipment.",
            null),
          ('Bugenhagen, Wise Elder', 'upkeep',
            'Karte ziehen', 'Draw a card',
            'At the beginning of your upkeep, if you control a creature with power 7 or greater, draw a card.',
            'if you control a creature with power 7 or greater'),
          ("Citizen's Crowbar", 'continuousEffect',
            '+1/+1', '+1/+1',
            'Equipped creature gets +1/+1.',
            null),
          ('Colossus Hammer', 'continuousEffect',
            '+10/+10, verliert Fliegend', '+10/+10, loses flying',
            'Equipped creature gets +10/+10 and loses flying.',
            null),
          ('Conformer Shuriken', 'attacks',
            'Verteidiger-Kreatur tappen', 'Tap defending creature',
            'Equipped creature has "Whenever this creature attacks, tap target creature defending player controls. If that creature has greater power than this creature, put a number of +1/+1 counters on this creature equal to the difference."',
            null),
          ('Envoy of the Ancestors', 'continuousEffect',
            'Modifizierte Kreaturen: Lebensband', 'Modified creatures have lifelink',
            'Other modified creatures you control have lifelink.',
            null),
          ('Firion, Wild Rose Warrior', 'continuousEffect',
            'Ausgerüstete Kreaturen: Eile', 'Equipped creatures have haste',
            'Equipped creatures you control have haste.',
            null),
          ('Firion, Wild Rose Warrior', 'enterBattlefield',
            'Ausrüstungs-Kopie als Token', 'Create Equipment token copy',
            'Whenever a nontoken Equipment you control enters, create a token that\'s a copy of it, except it has "This Equipment\'s equip abilities cost {2} less to activate." Sacrifice that token at the beginning of the next upkeep.',
            null),
          ('Godsend', 'continuousEffect',
            '+3/+3', '+3/+3',
            'Equipped creature gets +3/+3.',
            null),
          ('Godsend', 'blocks',
            'Blockende/geblockte Kreatur verbannen', 'Exile blocking/blocked creature',
            'Whenever equipped creature blocks or becomes blocked by one or more creatures, you may exile one of those creatures.',
            null),
          ('Golden-Tail Trainer', 'continuousEffect',
            'Rabatt: Aura/Ausrüstungs-Sprüche (= Stärke)', 'Aura/Equipment spells cost less (= power)',
            'Aura and Equipment spells you cast cost {X} less to cast, where X is this creature\'s power.',
            null),
          ('Golden-Tail Trainer', 'attacks',
            'Modifizierte Kreaturen +X/+X (= Stärke)', 'Modified creatures get +X/+X (= power)',
            'Whenever this creature attacks, other modified creatures you control get +X/+X until end of turn, where X is this creature\'s power.',
            null),
          ('Hammer of Nazahn', 'continuousEffect',
            '+2/+0, Unzerstörbar', '+2/+0, indestructible',
            'Equipped creature gets +2/+0 and has indestructible.',
            null),
          ('Hammer of Nazahn', 'enterBattlefield',
            'Ausrüstung anlegen', 'Attach Equipment',
            'Whenever Hammer of Nazahn or another Equipment you control enters, you may attach that Equipment to target creature you control.',
            null),
          ('Heartseeker', 'continuousEffect',
            '+2/+1', '+2/+1',
            'Equipped creature gets +2/+1 and has "{T}, Unattach Heartseeker: Destroy target creature."',
            null),
          ('Kodama of the West Tree', 'continuousEffect',
            'Modifizierte Kreaturen: Trampeln', 'Modified creatures have trample',
            'Modified creatures you control have trample.',
            null),
          ('Kodama of the West Tree', 'dealsCombatDamage',
            'Basisland suchen und anlegen', 'Search for basic land',
            'Whenever a modified creature you control deals combat damage to a player, search your library for a basic land card, put it onto the battlefield tapped, then shuffle.',
            'modified creature'),
          ('Meteor Sword', 'continuousEffect',
            '+3/+3', '+3/+3',
            'Equipped creature gets +3/+3.',
            null),
          ('Puresteel Paladin', 'enterBattlefield',
            'Karte ziehen', 'Draw a card',
            'Whenever an Equipment you control enters, you may draw a card.',
            null),
          ('Puresteel Paladin', 'continuousEffect',
            'Metalcraft: Ausrüstungen anlegen {0}', 'Metalcraft: equip {0}',
            'Metalcraft — Equipment you control have equip {0} as long as you control three or more artifacts.',
            'if you control three or more artifacts'),
          ('Quietus Spike', 'continuousEffect',
            'Todesberührung', 'Deathtouch',
            'Equipped creature has deathtouch.',
            null),
          ('Quietus Spike', 'dealsCombatDamage',
            'Gegner verliert halbe Leben', 'Player loses half life',
            'Whenever equipped creature deals combat damage to a player, that player loses half their life, rounded up.',
            null),
          ('Red XIII, Proud Warrior', 'continuousEffect',
            'Modifizierte Kreaturen: Wachsamkeit + Trampeln', 'Modified creatures have vigilance and trample',
            'Other modified creatures you control have vigilance and trample.',
            null),
          ('Reyav, Master Smith', 'attacks',
            'Doppelstrike (ausgerüstet/verzaubert)', 'Double strike (equipped/enchanted)',
            'Whenever a creature you control that\'s enchanted or equipped attacks, that creature gains double strike until end of turn.',
            "that's enchanted or equipped"),
          ("Summoner's Grimoire", 'attacks',
            'Kreatur aus Hand ins Spiel', 'Put creature from hand into play',
            'Equipped creature has "Whenever this creature attacks, you may put a creature card from your hand onto the battlefield. If that card is an enchantment card, it enters tapped and attacking."',
            null),
          ('Sword of the Animist', 'continuousEffect',
            '+1/+1', '+1/+1',
            'Equipped creature gets +1/+1.',
            null),
          ('Sword of the Animist', 'attacks',
            'Basisland suchen und anlegen', 'Search for basic land',
            'Whenever equipped creature attacks, you may search your library for a basic land card, put it onto the battlefield tapped, then shuffle.',
            null),
        ];
        for (final (name, trigger, de, en, desc, condition) in effects) {
          await customStatement(
            '''INSERT INTO card_effects
                 (card_definition_id, trigger, short_label, short_label_en, description, trigger_condition_text)
               SELECT cd.id, ?, ?, ?, ?, ?
               FROM card_definitions cd
               WHERE cd.name = ?
                 AND NOT EXISTS (
                   SELECT 1 FROM card_effects
                   WHERE card_definition_id = cd.id AND description = ?
                 )''',
            [trigger, de, en, desc, condition, name, desc],
          );
        }
      }
      if (from < 18) {
        await m.addColumn(cardEffects, cardEffects.effectType);
      }
      if (from < 19) {
        await m.addColumn(cardEffects, cardEffects.ceScope);
        await m.createTable(cardAttachments);
      }
      if (from < 20) {
        // Gelernte Regeln zurücksetzen: alte shortLabelTemplates enthielten den
        // Trigger-Typ-Namen statt des Effekts (z.B. 'Nicht-Kampfschaden').
        // Der Parser baut die Tabelle beim nächsten "Effekte analysieren" neu
        // auf — diesmal mit korrekten Effekt-Labels.
        await customStatement('DELETE FROM learned_rules');
        // spellResolved-Effekte entfernen: eigene Spell-Effekte werden nicht
        // mehr in der DB gespeichert, sondern im Cast-Spell-Screen on-the-fly
        // aus dem Oracle-Text geparst.
        await customStatement(
            "DELETE FROM card_effects WHERE trigger = 'spellResolved'");
      }
      if (from < 21) {
        await m.addColumn(cardEffects, cardEffects.effectDetail);
        await m.addColumn(cardEffects, cardEffects.effectExtraConditions);
        await m.addColumn(learnedRules, learnedRules.effectDetail);
        await m.addColumn(learnedRules, learnedRules.effectExtraConditions);
      }
      if (from < 22) {
        // ── Trigger-Korrekturen ─────────────────────────────────────────────

        // Satyr Firedancer: Instant/Sorcery-Einschränkung im Trigger fehlt.
        await customStatement(
          "UPDATE card_effects SET spell_category = 'instantOrSorcery'"
          " WHERE card_definition_id = (SELECT id FROM card_definitions WHERE name = 'Satyr Firedancer')"
          "   AND trigger = 'spellDealsDamage' AND (spell_category IS NULL OR spell_category = '')",
        );

        // Imodane the Pyrohammer: Instant/Sorcery + Einzelziel-Kreatur.
        await customStatement(
          "UPDATE card_effects SET spell_category = 'instantOrSorcery',"
          "  extra_conditions = 'singleCreatureTarget'"
          " WHERE card_definition_id = (SELECT id FROM card_definitions WHERE name = 'Imodane the Pyrohammer')"
          "   AND trigger = 'spellDealsDamage'",
        );

        // Chandra's Incinerator: Trigger braucht damageToOpponent-Einschränkung.
        await customStatement(
          "UPDATE card_effects SET extra_conditions = 'damageToOpponent'"
          " WHERE card_definition_id = (SELECT id FROM card_definitions WHERE name = \"Chandra's Incinerator\")"
          "   AND trigger = 'dealsNoncombatDamage'"
          "   AND (extra_conditions IS NULL OR extra_conditions = '' OR extra_conditions NOT LIKE '%damageToOpponent%')",
        );

        // ── Effekt-Label-Korrekturen ────────────────────────────────────────

        // Caldera Pyremaw: "+" raus aus shortLabel, damageAmount setzen.
        await customStatement(
          "UPDATE card_effects SET short_label = '1/+1, 1 Schaden an Gegner',"
          "  short_label_en = '+1/+1, 1 damage to opponent', damage_amount = 1"
          " WHERE card_definition_id = (SELECT id FROM card_definitions WHERE name = 'Caldera Pyremaw')"
          "   AND short_label LIKE '%1/+1%'",
        );

        // Coruscation Mage / Guttersnipe: "+" vor Schadensziffer entfernen.
        await customStatement(
          "UPDATE card_effects SET short_label = REPLACE(short_label, '+', '')"
          " WHERE trigger = 'castSpell'"
          "   AND short_label GLOB '+[0-9]*'"
          "   AND card_definition_id IN ("
          "     SELECT id FROM card_definitions WHERE name IN ('Coruscation Mage', 'Guttersnipe')"
          "   )",
        );
        await customStatement(
          "UPDATE card_effects SET short_label_en = REPLACE(short_label_en, '+', '')"
          " WHERE trigger = 'castSpell'"
          "   AND short_label_en GLOB '+[0-9]*'"
          "   AND card_definition_id IN ("
          "     SELECT id FROM card_definitions WHERE name IN ('Coruscation Mage', 'Guttersnipe')"
          "   )",
        );

        // Tunneling Geopede: "Landfall:" Präfix raus.
        await customStatement(
          "UPDATE card_effects SET"
          "  short_label = REPLACE(short_label, 'Landfall: ', ''),"
          "  short_label_en = REPLACE(short_label_en, 'Landfall: ', '')"
          " WHERE card_definition_id = (SELECT id FROM card_definitions WHERE name = 'Tunneling Geopede')"
          "   AND (short_label LIKE 'Landfall: %' OR short_label_en LIKE 'Landfall: %')",
        );

        // Spinerock Tyrant: Kategorie-Präfix aus shortLabel entfernen, Effekt-Label korrigieren.
        await customStatement(
          "UPDATE card_effects SET"
          "  short_label = 'Spruch kopieren + Wither',"
          "  short_label_en = 'Copy spell + Wither'"
          " WHERE card_definition_id = (SELECT id FROM card_definitions WHERE name = 'Spinerock Tyrant')"
          "   AND trigger = 'castSpell'",
        );

        // Backdraft Hellkite: effectDetail für Flashback-Einschränkung setzen.
        await customStatement(
          "UPDATE card_effects SET effect_detail = 'Instant/Sorcery; Flashback Cost = Mana Cost'"
          " WHERE card_definition_id = (SELECT id FROM card_definitions WHERE name = 'Backdraft Hellkite')"
          "   AND trigger = 'attacks'"
          "   AND (short_label LIKE '%Flashback%' OR short_label LIKE '%flashback%')",
        );

        // Dwarven Mine: selbstbezogener ETB-Token-Trigger, nicht sinnvoll zu tracken.
        await customStatement(
          "DELETE FROM card_effects"
          " WHERE card_definition_id = (SELECT id FROM card_definitions WHERE name = 'Dwarven Mine')"
          "   AND trigger = 'enterBattlefield'",
        );

        // ── Continuous Effects: triggerConditionText → effectDetail ─────────

        // Longshot Squad: Kostenreduzierungs-Bedingung ist Effekt-Einschränkung.
        await customStatement(
          "UPDATE card_effects SET"
          "  effect_detail = trigger_condition_text,"
          "  trigger_condition_text = NULL"
          " WHERE card_definition_id = (SELECT id FROM card_definitions WHERE name = 'Longshot Squad')"
          "   AND trigger = 'continuousEffect'"
          "   AND trigger_condition_text IS NOT NULL",
        );

        // Sawhorn Nemesis: Replacement-Effekt-Bedingung ist Effekt-Einschränkung.
        await customStatement(
          "UPDATE card_effects SET"
          "  effect_detail = trigger_condition_text,"
          "  trigger_condition_text = NULL"
          " WHERE card_definition_id = (SELECT id FROM card_definitions WHERE name = 'Sawhorn Nemesis')"
          "   AND trigger = 'staticDamageModifier'"
          "   AND trigger_condition_text IS NOT NULL",
        );
      }
      if (from < 23) {
        // Satyr Firedancer: damageToOpponent-Einschränkung ergänzen.
        // (v22 hat spell_category gesetzt, extra_conditions fehlte noch.)
        await customStatement(
          "UPDATE card_effects"
          " SET extra_conditions = CASE"
          "   WHEN extra_conditions IS NULL OR extra_conditions = '' THEN 'damageToOpponent'"
          "   ELSE extra_conditions || ',damageToOpponent'"
          "   END"
          " WHERE card_definition_id = (SELECT id FROM card_definitions WHERE name = 'Satyr Firedancer')"
          "   AND trigger = 'spellDealsDamage'"
          "   AND (extra_conditions IS NULL OR extra_conditions NOT LIKE '%damageToOpponent%')",
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
