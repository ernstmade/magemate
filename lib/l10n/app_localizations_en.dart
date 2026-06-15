// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Magic Support';

  @override
  String get navPlay => 'Play';

  @override
  String get navDecks => 'Decks';

  @override
  String get navTriggers => 'Triggers';

  @override
  String get navSettings => 'Settings';

  @override
  String get noActiveDeck => 'No active deck selected.';

  @override
  String get selectDeckHint =>
      'Pick a deck below to use it as your active deck.';

  @override
  String get activeDeck => 'Active deck';

  @override
  String get decksTitle => 'Decks';

  @override
  String get decksEmpty => 'No decks yet. Tap + to create one.';

  @override
  String get newDeck => 'New deck';

  @override
  String get deckName => 'Deck name';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionCreate => 'Create';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionClose => 'Close';

  @override
  String get cardsTitle => 'Cards';

  @override
  String get cardsEmpty => 'No cards yet. Tap + to add one.';

  @override
  String get newCard => 'New card';

  @override
  String get cardName => 'Card name';

  @override
  String get inPlay => 'In play';

  @override
  String get importDeck => 'Import deck';

  @override
  String importSuccess(int count) {
    return 'Imported $count card lines.';
  }

  @override
  String get importEmptyError => 'No cards found in this file.';

  @override
  String importFailed(String message) {
    return 'Import failed: $message';
  }

  @override
  String get tabDeck => 'Deck';

  @override
  String get tabInPlay => 'In play';

  @override
  String get inPlayEmpty => 'No cards in play yet. Mark cards on the Deck tab.';

  @override
  String get cardInfo => 'Card info';

  @override
  String get cardHasEffects => 'This card has effects';

  @override
  String get cardInfoOracleText => 'Oracle text';

  @override
  String get cardInfoEffectsTitle => 'Effects';

  @override
  String get cardInfoNoEffects => 'No effects recorded yet.';

  @override
  String get cardInfoTriggerLabel => 'Trigger';

  @override
  String get cardInfoSpellCategoryLabel => 'Reacts to';

  @override
  String get cardInfoShortLabelLabel => 'Short label';

  @override
  String get cardInfoEffectDescriptionLabel => 'Effect description';

  @override
  String get cardInfoAddEffect => 'Add effect';

  @override
  String get castSpell => 'Cast';

  @override
  String get castSpellSheetTitle => 'Effects when casting an instant/sorcery';

  @override
  String get castSpellSectionCast => 'On cast';

  @override
  String get castSpellSectionCastHint =>
      'Triggers from casting the instant/sorcery itself.';

  @override
  String get castSpellSectionDamage => 'Caused damage to opponents';

  @override
  String get castSpellSectionDamageHint =>
      'If the spell or one of the effects above dealt noncombat damage to an opponent, these also trigger.';

  @override
  String get castSpellSectionSpellDamage =>
      'Spell damage to a creature/permanent';

  @override
  String get castSpellSectionSpellDamageHint =>
      'If the spell dealt damage to a creature or permanent, these also trigger.';

  @override
  String get castSpellSectionStaticModifiers => 'Damage modifiers';

  @override
  String get castSpellSectionStaticModifiersHint =>
      'Apply to any damage from the effects above, if the condition matches (e.g. only red sources).';

  @override
  String get cardInfoNoData => 'No additional data yet.';

  @override
  String get sortTooltip => 'Sort';

  @override
  String get sortAlphabetical => 'Alphabetical';

  @override
  String get sortByType => 'By type';

  @override
  String get enrichFromScryfall => 'Load card data';

  @override
  String enrichSuccess(int count) {
    return 'Updated $count cards from Scryfall.';
  }

  @override
  String enrichFailed(String message) {
    return 'Loading card data failed: $message';
  }

  @override
  String get triggersTitle => 'Triggers';

  @override
  String get triggersHint =>
      'Select a trigger to see matching effects from cards in play.';

  @override
  String get noMatchingEffects => 'No effects in play match this trigger.';

  @override
  String get noActiveTriggers => 'No cards in play have effects.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System';
}
