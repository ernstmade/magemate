// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppL10nDe extends AppL10n {
  AppL10nDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Magic Support';

  @override
  String get navPlay => 'Spiel';

  @override
  String get navDecks => 'Decks';

  @override
  String get navTriggers => 'Trigger';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get noActiveDeck => 'Kein aktives Deck ausgewählt.';

  @override
  String get selectDeckHint => 'Wähle unten ein Deck als aktives Deck aus.';

  @override
  String get activeDeck => 'Aktives Deck';

  @override
  String get decksTitle => 'Decks';

  @override
  String get decksEmpty => 'Noch keine Decks. Tippe auf +, um eines anzulegen.';

  @override
  String get newDeck => 'Neues Deck';

  @override
  String get deckName => 'Deckname';

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get actionCreate => 'Erstellen';

  @override
  String get actionDelete => 'Löschen';

  @override
  String get actionClose => 'Schließen';

  @override
  String get cardsTitle => 'Karten';

  @override
  String get cardsEmpty =>
      'Noch keine Karten. Tippe auf +, um eine hinzuzufügen.';

  @override
  String get newCard => 'Neue Karte';

  @override
  String get cardName => 'Kartenname';

  @override
  String get inPlay => 'Im Spiel';

  @override
  String get importDeck => 'Deck importieren';

  @override
  String importSuccess(int count) {
    return '$count Kartenzeilen importiert.';
  }

  @override
  String get importEmptyError => 'Keine Karten in dieser Datei gefunden.';

  @override
  String importFailed(String message) {
    return 'Import fehlgeschlagen: $message';
  }

  @override
  String get tabDeck => 'Deck';

  @override
  String get tabInPlay => 'Im Spiel';

  @override
  String get inPlayEmpty =>
      'Noch keine Karten im Spiel. Markiere Karten im Tab \"Deck\".';

  @override
  String get cardInfo => 'Karteninfo';

  @override
  String get cardHasEffects => 'Diese Karte hat Effekte';

  @override
  String get cardInfoOracleText => 'Kartentext';

  @override
  String get cardInfoEffectsTitle => 'Effekte';

  @override
  String get cardInfoNoEffects => 'Noch keine Effekte erfasst.';

  @override
  String get cardInfoTriggerLabel => 'Trigger';

  @override
  String get cardInfoSpellCategoryLabel => 'Reagiert auf';

  @override
  String get cardInfoShortLabelLabel => 'Kurzform';

  @override
  String get cardInfoEffectDescriptionLabel => 'Effektbeschreibung';

  @override
  String get cardInfoAddEffect => 'Effekt hinzufügen';

  @override
  String get castSpell => 'Gespielt';

  @override
  String get castSpellSheetTitle =>
      'Effekte beim Spielen eines Instant/Sorcery';

  @override
  String get castSpellSectionCast => 'Beim Spielen';

  @override
  String get castSpellSectionCastHint =>
      'Trigger durch das Spielen des Instant/Sorcery selbst.';

  @override
  String get castSpellSectionDamage => 'Dadurch verursachter Schaden an Gegner';

  @override
  String get castSpellSectionDamageHint =>
      'Falls der Spruch oder einer der obigen Effekte Noncombat-Schaden an einen Gegner verursacht hat, triggern auch diese.';

  @override
  String get castSpellSectionSpellDamage =>
      'Spruch-Schaden an Kreatur/Permanent';

  @override
  String get castSpellSectionSpellDamageHint =>
      'Falls der Spruch Schaden an eine Kreatur oder ein Permanent verursacht hat, triggern auch diese.';

  @override
  String get castSpellSectionStaticModifiers => 'Schadensmodifikatoren';

  @override
  String get castSpellSectionStaticModifiersHint =>
      'Gelten für jeglichen Schaden aus den obigen Effekten, falls die Bedingung passt (z.B. nur rote Quellen).';

  @override
  String get cardInfoNoData => 'Noch keine weiteren Daten vorhanden.';

  @override
  String get sortTooltip => 'Sortierung';

  @override
  String get sortAlphabetical => 'Alphabetisch';

  @override
  String get sortByType => 'Nach Typ';

  @override
  String get enrichFromScryfall => 'Karteninfos laden';

  @override
  String enrichSuccess(int count) {
    return '$count Karten von Scryfall aktualisiert.';
  }

  @override
  String enrichFailed(String message) {
    return 'Laden der Karteninfos fehlgeschlagen: $message';
  }

  @override
  String get triggersTitle => 'Trigger';

  @override
  String get triggersHint =>
      'Wähle einen Trigger, um passende Effekte der gespielten Karten zu sehen.';

  @override
  String get noMatchingEffects =>
      'Keine im Spiel befindlichen Effekte passen zu diesem Trigger.';

  @override
  String get noActiveTriggers =>
      'Keine im Spiel befindlichen Karten haben Effekte.';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageSystem => 'System';
}
