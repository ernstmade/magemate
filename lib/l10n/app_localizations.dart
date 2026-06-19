import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Magemate'**
  String get appTitle;

  /// No description provided for @navPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get navPlay;

  /// No description provided for @navDecks.
  ///
  /// In en, this message translates to:
  /// **'Decks'**
  String get navDecks;

  /// No description provided for @navTriggers.
  ///
  /// In en, this message translates to:
  /// **'Triggers'**
  String get navTriggers;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @noActiveDeck.
  ///
  /// In en, this message translates to:
  /// **'No active deck selected.'**
  String get noActiveDeck;

  /// No description provided for @selectDeckHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a deck below to use it as your active deck.'**
  String get selectDeckHint;

  /// No description provided for @activeDeck.
  ///
  /// In en, this message translates to:
  /// **'Active deck'**
  String get activeDeck;

  /// No description provided for @decksTitle.
  ///
  /// In en, this message translates to:
  /// **'Decks'**
  String get decksTitle;

  /// No description provided for @decksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No decks yet. Tap + to create one.'**
  String get decksEmpty;

  /// No description provided for @newDeck.
  ///
  /// In en, this message translates to:
  /// **'New deck'**
  String get newDeck;

  /// No description provided for @deckName.
  ///
  /// In en, this message translates to:
  /// **'Deck name'**
  String get deckName;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get actionCreate;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @cardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cardsTitle;

  /// No description provided for @cardsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No cards yet. Tap + to add one.'**
  String get cardsEmpty;

  /// No description provided for @newCard.
  ///
  /// In en, this message translates to:
  /// **'New card'**
  String get newCard;

  /// No description provided for @cardName.
  ///
  /// In en, this message translates to:
  /// **'Card name'**
  String get cardName;

  /// No description provided for @inPlay.
  ///
  /// In en, this message translates to:
  /// **'In play'**
  String get inPlay;

  /// No description provided for @importDeck.
  ///
  /// In en, this message translates to:
  /// **'Import deck'**
  String get importDeck;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} card lines.'**
  String importSuccess(int count);

  /// No description provided for @importEmptyError.
  ///
  /// In en, this message translates to:
  /// **'No cards found in this file.'**
  String get importEmptyError;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {message}'**
  String importFailed(String message);

  /// No description provided for @tabDeck.
  ///
  /// In en, this message translates to:
  /// **'Deck'**
  String get tabDeck;

  /// No description provided for @tabInPlay.
  ///
  /// In en, this message translates to:
  /// **'In play'**
  String get tabInPlay;

  /// No description provided for @inPlayEmpty.
  ///
  /// In en, this message translates to:
  /// **'No cards in play yet. Mark cards on the Deck tab.'**
  String get inPlayEmpty;

  /// No description provided for @cardInfo.
  ///
  /// In en, this message translates to:
  /// **'Card info'**
  String get cardInfo;

  /// No description provided for @cardHasEffects.
  ///
  /// In en, this message translates to:
  /// **'This card has effects'**
  String get cardHasEffects;

  /// No description provided for @cardInfoOracleText.
  ///
  /// In en, this message translates to:
  /// **'Oracle text'**
  String get cardInfoOracleText;

  /// No description provided for @cardInfoEffectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Effects'**
  String get cardInfoEffectsTitle;

  /// No description provided for @cardInfoNoEffects.
  ///
  /// In en, this message translates to:
  /// **'No effects recorded yet.'**
  String get cardInfoNoEffects;

  /// No description provided for @cardInfoTriggerLabel.
  ///
  /// In en, this message translates to:
  /// **'Trigger'**
  String get cardInfoTriggerLabel;

  /// No description provided for @cardInfoSpellCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Reacts to'**
  String get cardInfoSpellCategoryLabel;

  /// No description provided for @cardInfoTriggerDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get cardInfoTriggerDetailLabel;

  /// No description provided for @cardInfoSingleTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Single target only'**
  String get cardInfoSingleTargetLabel;

  /// No description provided for @effectConditionSingleTarget.
  ///
  /// In en, this message translates to:
  /// **'Single target only'**
  String get effectConditionSingleTarget;

  /// No description provided for @effectConditionSingleCreatureTarget.
  ///
  /// In en, this message translates to:
  /// **'Single creature target only'**
  String get effectConditionSingleCreatureTarget;

  /// No description provided for @effectConditionDamageToOpponent.
  ///
  /// In en, this message translates to:
  /// **'Damage to opponent'**
  String get effectConditionDamageToOpponent;

  /// No description provided for @cardInfoDamageAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Damage'**
  String get cardInfoDamageAmountLabel;

  /// No description provided for @cardInfoDamageMultiplierLabel.
  ///
  /// In en, this message translates to:
  /// **'Multiplier (×)'**
  String get cardInfoDamageMultiplierLabel;

  /// No description provided for @cardInfoDamageMinimumLabel.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get cardInfoDamageMinimumLabel;

  /// No description provided for @cardInfoReplacementScopeLabel.
  ///
  /// In en, this message translates to:
  /// **'Applies to'**
  String get cardInfoReplacementScopeLabel;

  /// No description provided for @cardInfoReplacementScopeAll.
  ///
  /// In en, this message translates to:
  /// **'Opponents + creatures'**
  String get cardInfoReplacementScopeAll;

  /// No description provided for @cardInfoReplacementScopeOpponentOnly.
  ///
  /// In en, this message translates to:
  /// **'Opponents only'**
  String get cardInfoReplacementScopeOpponentOnly;

  /// No description provided for @cardInfoDynamicDamageLabel.
  ///
  /// In en, this message translates to:
  /// **'Derive damage from spell (e.g. Imodane)'**
  String get cardInfoDynamicDamageLabel;

  /// No description provided for @cardInfoDamageTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get cardInfoDamageTargetLabel;

  /// No description provided for @castSpellDamageSummaryEachOpponent.
  ///
  /// In en, this message translates to:
  /// **'Total damage to each opponent'**
  String get castSpellDamageSummaryEachOpponent;

  /// No description provided for @castSpellDamageSummarySingleOpponent.
  ///
  /// In en, this message translates to:
  /// **'Total damage to one opponent'**
  String get castSpellDamageSummarySingleOpponent;

  /// No description provided for @castSpellDamageSummarySingleCreature.
  ///
  /// In en, this message translates to:
  /// **'Total damage to a creature/permanent'**
  String get castSpellDamageSummarySingleCreature;

  /// No description provided for @castSpellDamageSummaryEachCreature.
  ///
  /// In en, this message translates to:
  /// **'Total damage to each creature'**
  String get castSpellDamageSummaryEachCreature;

  /// No description provided for @castSpellDamageSummaryEachOpponentCreatures.
  ///
  /// In en, this message translates to:
  /// **'Total damage to each opponent\'s creatures'**
  String get castSpellDamageSummaryEachOpponentCreatures;

  /// No description provided for @cardInfoShortLabelLabel.
  ///
  /// In en, this message translates to:
  /// **'Short label (DE)'**
  String get cardInfoShortLabelLabel;

  /// No description provided for @cardInfoShortLabelEnLabel.
  ///
  /// In en, this message translates to:
  /// **'Short label (EN)'**
  String get cardInfoShortLabelEnLabel;

  /// No description provided for @cardInfoEffectDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Effect description'**
  String get cardInfoEffectDescriptionLabel;

  /// No description provided for @cardInfoEditEffects.
  ///
  /// In en, this message translates to:
  /// **'Edit effects'**
  String get cardInfoEditEffects;

  /// No description provided for @cardInfoAddEffect.
  ///
  /// In en, this message translates to:
  /// **'Add effect'**
  String get cardInfoAddEffect;

  /// No description provided for @castSpell.
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get castSpell;

  /// No description provided for @castSpellSectionReplacement.
  ///
  /// In en, this message translates to:
  /// **'Replacement effects'**
  String get castSpellSectionReplacement;

  /// No description provided for @castSpellSectionReplacementHint.
  ///
  /// In en, this message translates to:
  /// **'Modify damage values at every level (own effect, triggered effects, follow-up effects) if the condition matches (e.g. only red sources). Apply these first.'**
  String get castSpellSectionReplacementHint;

  /// No description provided for @castSpellSectionOwnEffect.
  ///
  /// In en, this message translates to:
  /// **'Own effect'**
  String get castSpellSectionOwnEffect;

  /// No description provided for @castSpellSectionCast.
  ///
  /// In en, this message translates to:
  /// **'Triggered effects on other cards'**
  String get castSpellSectionCast;

  /// No description provided for @castSpellSectionCastHint.
  ///
  /// In en, this message translates to:
  /// **'Effects from other cards in play that trigger when this spell is cast.'**
  String get castSpellSectionCastHint;

  /// No description provided for @followUpHint.
  ///
  /// In en, this message translates to:
  /// **'Check for possible follow-up effects'**
  String get followUpHint;

  /// No description provided for @castSpellSectionFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Follow-up effects'**
  String get castSpellSectionFollowUp;

  /// No description provided for @castSpellSectionDamageHint.
  ///
  /// In en, this message translates to:
  /// **'Triggers if the spell or one of the effects above dealt noncombat damage to an opponent.'**
  String get castSpellSectionDamageHint;

  /// No description provided for @castSpellSectionSpellDamageHint.
  ///
  /// In en, this message translates to:
  /// **'Triggers if the spell dealt damage to a creature or permanent.'**
  String get castSpellSectionSpellDamageHint;

  /// No description provided for @cardInfoNoData.
  ///
  /// In en, this message translates to:
  /// **'No additional data yet.'**
  String get cardInfoNoData;

  /// No description provided for @cardTypeCreature.
  ///
  /// In en, this message translates to:
  /// **'Creature'**
  String get cardTypeCreature;

  /// No description provided for @cardTypeArtifact.
  ///
  /// In en, this message translates to:
  /// **'Artifact'**
  String get cardTypeArtifact;

  /// No description provided for @cardTypeInstant.
  ///
  /// In en, this message translates to:
  /// **'Instant'**
  String get cardTypeInstant;

  /// No description provided for @cardTypeSorcery.
  ///
  /// In en, this message translates to:
  /// **'Sorcery'**
  String get cardTypeSorcery;

  /// No description provided for @cardTypeLand.
  ///
  /// In en, this message translates to:
  /// **'Land'**
  String get cardTypeLand;

  /// No description provided for @cardTypeEnchantment.
  ///
  /// In en, this message translates to:
  /// **'Enchantment'**
  String get cardTypeEnchantment;

  /// No description provided for @cardTypePlaneswalker.
  ///
  /// In en, this message translates to:
  /// **'Planeswalker'**
  String get cardTypePlaneswalker;

  /// No description provided for @sortTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortTooltip;

  /// No description provided for @sortAlphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get sortAlphabetical;

  /// No description provided for @sortByType.
  ///
  /// In en, this message translates to:
  /// **'By type'**
  String get sortByType;

  /// No description provided for @sortByTypeCmc.
  ///
  /// In en, this message translates to:
  /// **'By type / CMC'**
  String get sortByTypeCmc;

  /// No description provided for @sortByTypeAlpha.
  ///
  /// In en, this message translates to:
  /// **'By type / Alphabet'**
  String get sortByTypeAlpha;

  /// No description provided for @enrichFromScryfall.
  ///
  /// In en, this message translates to:
  /// **'Load card data'**
  String get enrichFromScryfall;

  /// No description provided for @enrichSuccess.
  ///
  /// In en, this message translates to:
  /// **'Updated {count} cards from Scryfall.'**
  String enrichSuccess(int count);

  /// No description provided for @enrichFailed.
  ///
  /// In en, this message translates to:
  /// **'Loading card data failed: {message}'**
  String enrichFailed(String message);

  /// No description provided for @triggersTitle.
  ///
  /// In en, this message translates to:
  /// **'Triggers'**
  String get triggersTitle;

  /// No description provided for @triggersHint.
  ///
  /// In en, this message translates to:
  /// **'Select a trigger to see matching effects from cards in play.'**
  String get triggersHint;

  /// No description provided for @noActiveTriggers.
  ///
  /// In en, this message translates to:
  /// **'No cards in play have effects.'**
  String get noActiveTriggers;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @roundReset.
  ///
  /// In en, this message translates to:
  /// **'New round'**
  String get roundReset;

  /// No description provided for @roundResetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Return all cards to hand?'**
  String get roundResetConfirm;

  /// No description provided for @cardRatingTitle.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get cardRatingTitle;

  /// No description provided for @cardRatingNone.
  ///
  /// In en, this message translates to:
  /// **'Not rated'**
  String get cardRatingNone;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsLanguageSystem;

  /// No description provided for @effectSuggestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Detected effects'**
  String get effectSuggestionTitle;

  /// No description provided for @effectSuggestionHint.
  ///
  /// In en, this message translates to:
  /// **'Review the effects detected from card text. Deselect any that don\'t apply.'**
  String get effectSuggestionHint;

  /// No description provided for @effectSuggestionSave.
  ///
  /// In en, this message translates to:
  /// **'Save selection ({count})'**
  String effectSuggestionSave(int count);

  /// No description provided for @effectSuggestionSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get effectSuggestionSelectAll;

  /// No description provided for @effectSuggestionDeselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get effectSuggestionDeselectAll;

  /// No description provided for @effectSuggestionNone.
  ///
  /// In en, this message translates to:
  /// **'No new effects detected.'**
  String get effectSuggestionNone;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppL10nDe();
    case 'en':
      return AppL10nEn();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
