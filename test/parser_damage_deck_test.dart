import 'package:flutter_test/flutter_test.dart';
import 'package:magemate/data/parser/card_text_parser.dart';

void main() {
  void check(String cardName, String oracleText) {
    final results = CardTextParser.parse(oracleText, cardName: cardName);
    // ignore: avoid_print
    print('\n== $cardName ==');
    if (results.isEmpty) {
      // ignore: avoid_print
      print('  (kein Effekt erkannt)');
    } else {
      for (final r in results) {
        final detail  = r.triggerDetail != null ? '  detail=${r.triggerDetail}' : '';
        final conds   = r.extraConditions.isNotEmpty ? '  conds=${r.extraConditions.map((c) => c.name).join(",")}' : '';
        final dmg     = r.damageAmount != null ? '  dmg=${r.damageAmount}→${r.damageTarget?.name}' : '';
        final effCond = r.effectExtraConditions.isNotEmpty ? '  effConds=${r.effectExtraConditions.map((c) => c.name).join(",")}' : '';
        final effDet  = r.effectDetail != null ? '  effDetail=${r.effectDetail}' : '';
        // ignore: avoid_print
        print('  ${r.trigger.name}: "${r.shortLabel}" / "${r.shortLabelEn}"$detail$conds$dmg$effCond$effDet');
      }
    }
  }

  test('Damage Damage parser smoke-test', () {
    check('Backdraft Hellkite',
      'Flying\nWhenever this creature attacks, each instant and sorcery card in your graveyard gains flashback until end of turn. The flashback cost is equal to its mana cost.');
    check('Brash Taunter',
      'Indestructible\nWhenever this creature is dealt damage, it deals that much damage to target opponent.\n{2}{R}, {T}: This creature fights another target creature.');
    check('Caldera Pyremaw',
      'Flying\nWhenever you cast an instant or sorcery spell, put a +1/+1 counter on this creature. Then this creature deals damage equal to its power to target opponent.');
    check('Dwarven Mine',
      '({T}: Add {R}.)\nThis land enters tapped unless you control three or more other Mountains.\nWhen this land enters untapped, create a 1/1 red Dwarf creature token.');
    check('Imodane, the Pyrohammer',
      'Whenever an instant or sorcery spell you control that targets only a single creature deals damage to that creature, Imodane deals that much damage to each opponent.');
    check('Longshot, Rebel Bowman',
      'Reach (This creature can block creatures with flying.)\nNoncreature spells you cast cost {1} less to cast.\nWhenever you cast a noncreature spell, Longshot deals 2 damage to each opponent.');
    check('Ojer Axonil, Deepest Might',
      'Trample\nIf a red source you control would deal an amount of noncombat damage less than Ojer Axonil\'s power to an opponent, that source deals damage equal to Ojer Axonil\'s power instead.\nWhen Ojer Axonil dies, return it to the battlefield tapped and transformed under its owner\'s control.');
    check('Sawhorn Nemesis',
      'As this creature enters, choose a player.\nIf a source would deal damage to the chosen player or a permanent they control, it deals double that damage instead.');
    check('Skullclamp',
      'Equipped creature gets +1/-1.\nWhenever equipped creature dies, draw two cards.\nEquip {1}');
    check('Spinerock Tyrant',
      'Flying\nWither (This deals damage to creatures in the form of -1/-1 counters.)\nWhenever you cast an instant or sorcery spell with a single target, you may copy it. If you do, those spells gain wither. You may choose new targets for the copy.');
    check('Tunneling Geopede',
      'Landfall — Whenever a land you control enters, this creature deals 1 damage to each opponent.');
    check("Chandra's Incinerator",
      "Flying\nWhenever you deal noncombat damage to an opponent, Chandra's Incinerator deals that much damage to target creature or planeswalker.");
  });

  test('spellResolved: Damage-Spells aus dem Damage-Damage-Deck', () {
    check('Lightning Bolt',
      'Lightning Bolt deals 3 damage to any target.');
    check('Boltwave',
      'Boltwave deals 3 damage to each opponent.');
    check('Abrade',
      'Choose one —\n• Abrade deals 3 damage to target creature.\n• Destroy target artifact.');
    check('Volcanic Spite',
      'Volcanic Spite deals 3 damage to target creature or planeswalker. You may put a card from your hand on the bottom of your library.');
    check('Fiery Confluence',
      'Choose three. You may choose the same mode more than once.\n• Fiery Confluence deals 1 damage to each creature.\n• Fiery Confluence deals 2 damage to each opponent.\n• Destroy target artifact.');
    check('Tectonic Hazard',
      'Tectonic Hazard deals 1 damage to each creature and each opponent.');
    check('Ojer Axonil, Deepest Might',
      'Trample\nIf a red source you control would deal an amount of noncombat damage less than Ojer Axonil\'s power to an opponent, that source deals damage equal to Ojer Axonil\'s power instead.\nWhen Ojer Axonil dies, return it to the battlefield tapped and transformed under its owner\'s control.');
    check('Coruscation Mage',
      'Whenever you cast a noncreature spell, Coruscation Mage deals 1 damage to each opponent.');
    check('Guttersnipe',
      'Whenever you cast an instant or sorcery spell, Guttersnipe deals 2 damage to each opponent.');
    check('Satyr Firedancer',
      'Whenever an instant or sorcery spell you control deals damage to an opponent, this creature deals that much damage to target creature that player controls.');
    check("Iroh's Demonstration",
      "Choose one —\n• Iroh's Demonstration deals 1 damage to each creature your opponents control.\n• Iroh's Demonstration deals 4 damage to target creature.");
    check('Suplex',
      "Choose one —\n• Suplex deals 3 damage to target creature. If that creature would die this turn, exile it instead.\n• Exile target artifact.");
  });
}
