// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Magemate';

  @override
  String get navPlay => 'Play';

  @override
  String get navDecks => 'Decks';

  @override
  String get navTriggers => 'Triggers';

  @override
  String get navSettings => 'Settings';

  @override
  String get navStatus => 'Status';

  @override
  String get statusTitle => 'Status';

  @override
  String get statusEmpty =>
      'No cards in play with continuous effects or keywords.';

  @override
  String get statusContinuousEffects => 'Continuous Effects';

  @override
  String get statusKeywords => 'Keywords';

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
  String get cardInfoTriggerDetailLabel => 'Condition';

  @override
  String get cardInfoSingleTargetLabel => 'Single target only';

  @override
  String get effectConditionSingleTarget => 'Single target only';

  @override
  String get effectConditionSingleCreatureTarget =>
      'Single creature target only';

  @override
  String get effectConditionDamageToOpponent => 'Damage to opponent';

  @override
  String get cardInfoDamageAmountLabel => 'Damage';

  @override
  String get cardInfoDamageMultiplierLabel => 'Multiplier (×)';

  @override
  String get cardInfoDamageMinimumLabel => 'Minimum';

  @override
  String get cardInfoReplacementScopeLabel => 'Applies to';

  @override
  String get cardInfoReplacementScopeAll => 'Opponents + creatures';

  @override
  String get cardInfoReplacementScopeOpponentOnly => 'Opponents only';

  @override
  String get cardInfoDynamicDamageLabel =>
      'Derive damage from spell (e.g. Imodane)';

  @override
  String get cardInfoDamageTargetLabel => 'Target';

  @override
  String get castSpellDamageSummaryEachOpponent =>
      'Total damage to each opponent';

  @override
  String get castSpellDamageSummarySingleOpponent =>
      'Total damage to one opponent';

  @override
  String get castSpellDamageSummarySingleCreature =>
      'Total damage to a creature/permanent';

  @override
  String get castSpellDamageSummaryEachCreature =>
      'Total damage to each creature';

  @override
  String get castSpellDamageSummaryEachOpponentCreatures =>
      'Total damage to each opponent\'s creatures';

  @override
  String get castSpellDamageSummaryAnyTarget => 'Total damage to any target';

  @override
  String get cardInfoShortLabelLabel => 'Short label (DE)';

  @override
  String get cardInfoShortLabelEnLabel => 'Short label (EN)';

  @override
  String get cardInfoEffectDescriptionLabel => 'Effect description';

  @override
  String get cardInfoEditEffects => 'Edit effects';

  @override
  String get cardInfoAddEffect => 'Add effect';

  @override
  String get castSpell => 'Cast';

  @override
  String get castSpellSectionReplacement => 'Replacement effects';

  @override
  String get castSpellSectionReplacementHint =>
      'Modify damage values at every level (own effect, triggered effects, follow-up effects) if the condition matches (e.g. only red sources). Apply these first.';

  @override
  String get castSpellSectionOwnEffect => 'Own effect';

  @override
  String get castSpellSectionCast => 'Triggered effects on other cards';

  @override
  String get castSpellSectionCastHint =>
      'Effects from other cards in play that trigger when this spell is cast.';

  @override
  String get followUpHint => 'Check for possible follow-up effects';

  @override
  String get castSpellSectionFollowUp => 'Follow-up effects';

  @override
  String get castSpellSectionDamageHint =>
      'Triggers if the spell or one of the effects above dealt noncombat damage to an opponent.';

  @override
  String get castSpellSectionSpellDamageHint =>
      'Triggers if the spell dealt damage to a creature or permanent.';

  @override
  String get cardInfoNoData => 'No additional data yet.';

  @override
  String get cardTypeCreature => 'Creature';

  @override
  String get cardTypeArtifact => 'Artifact';

  @override
  String get cardTypeInstant => 'Instant';

  @override
  String get cardTypeSorcery => 'Sorcery';

  @override
  String get cardTypeLand => 'Land';

  @override
  String get cardTypeEnchantment => 'Enchantment';

  @override
  String get cardTypePlaneswalker => 'Planeswalker';

  @override
  String get sortTooltip => 'Sort';

  @override
  String get sortAlphabetical => 'Alphabetical';

  @override
  String get sortByType => 'By type';

  @override
  String get sortByTypeCmc => 'By type / CMC';

  @override
  String get sortByTypeAlpha => 'By type / Alphabet';

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
  String get noActiveTriggers => 'No cards in play have effects.';

  @override
  String get actionSave => 'Save';

  @override
  String get roundReset => 'New round';

  @override
  String get roundResetConfirm => 'Return all cards to hand?';

  @override
  String get cardRatingTitle => 'Rating';

  @override
  String get cardRatingNone => 'Not rated';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get effectSuggestionTitle => 'Detected effects';

  @override
  String get effectSuggestionHint =>
      'Review the effects detected from card text. Deselect any that don\'t apply.';

  @override
  String effectSuggestionSave(int count) {
    return 'Save selection ($count)';
  }

  @override
  String get effectSuggestionSelectAll => 'Select all';

  @override
  String get effectSuggestionDeselectAll => 'Deselect all';

  @override
  String get effectSuggestionNone => 'No new effects detected.';

  @override
  String get newDeckTitle => 'New deck';

  @override
  String get newDeckNameHint => 'Deck name';

  @override
  String get newDeckImportFile => 'Import from file';

  @override
  String newDeckFileSelected(String name) {
    return 'File: $name';
  }

  @override
  String get analysisTitle => 'Analysing deck';

  @override
  String analysisFetchingCard(int done, int total) {
    return 'Loading card data ($done/$total)';
  }

  @override
  String get analysisParsing => 'Analysing effects…';

  @override
  String get analysisDoneTitle => 'Import complete';

  @override
  String analysisSummaryCards(int count) {
    return '$count cards';
  }

  @override
  String analysisSummaryTriggers(int count) {
    return '$count trigger effects detected';
  }

  @override
  String analysisSummaryContinuous(int count) {
    return '$count continuous effects detected';
  }

  @override
  String analysisSummaryKeywords(int count) {
    return '$count cards with keywords';
  }

  @override
  String analysisReviewButton(int count) {
    return 'Review effects ($count)';
  }

  @override
  String get analysisDoneButton => 'Done';

  @override
  String get boardMain => 'Mainboard';

  @override
  String get boardSide => 'Sideboard';

  @override
  String get manageDeck => 'Manage deck';

  @override
  String get scryfallSyncButton => 'Fetch Scryfall data';

  @override
  String get scryfallSyncTooltip => 'Fetch missing Scryfall data for this deck';

  @override
  String get scryfallSynced => 'Scryfall data available';

  @override
  String get scryfallMissing => 'Scryfall data missing';

  @override
  String get scryfallNoSetInfo => 'No set code – manually added';

  @override
  String get analyseEffectsTooltip => 'Analyse and record effects';

  @override
  String get effectsNotParsed => 'No effects recorded yet';

  @override
  String effectsParsed(int count) {
    return '$count effect(s) recorded';
  }

  @override
  String get equipmentPickerTitle => 'Equip to...';

  @override
  String equipmentAttachedTo(String name) {
    return 'Attached to: $name';
  }

  @override
  String get equipmentNotAttached => 'Not equipped';

  @override
  String get equipmentDetach => 'Detach';

  @override
  String get equipmentReattach => 'Re-equip';

  @override
  String get ceScopeSelf => 'Self';

  @override
  String get ceScopeOneTarget => 'Equipment / Aura';

  @override
  String get ceScopeGlobal => 'All owned';

  @override
  String get ceScopeConditional => 'Conditional';
}
