// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppL10nDe extends AppL10n {
  AppL10nDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Magemate';

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
  String get cardInfoTriggerDetailLabel => 'Bedingung';

  @override
  String get cardInfoSingleTargetLabel => 'Nur bei Einzelziel';

  @override
  String get effectConditionSingleTarget => 'Nur bei Einzelziel';

  @override
  String get effectConditionSingleCreatureTarget =>
      'Nur einzelne Kreatur als Ziel';

  @override
  String get effectConditionDamageToOpponent => 'Schaden an Gegner';

  @override
  String get cardInfoDamageAmountLabel => 'Schaden';

  @override
  String get cardInfoDamageMultiplierLabel => 'Multiplikator (×)';

  @override
  String get cardInfoDamageMinimumLabel => 'Minimum';

  @override
  String get cardInfoReplacementScopeLabel => 'Gilt für';

  @override
  String get cardInfoReplacementScopeAll => 'Gegner + Kreaturen';

  @override
  String get cardInfoReplacementScopeOpponentOnly => 'Nur Gegner';

  @override
  String get cardInfoDynamicDamageLabel =>
      'Schaden vom Spell übernehmen (z.B. Imodane)';

  @override
  String get cardInfoDamageTargetLabel => 'Ziel';

  @override
  String get castSpellDamageSummaryEachOpponent =>
      'Summe Schaden an jeden Gegner';

  @override
  String get castSpellDamageSummarySingleOpponent =>
      'Summe Schaden an einen Gegner';

  @override
  String get castSpellDamageSummarySingleCreature =>
      'Summe Schaden an eine Kreatur/Permanent';

  @override
  String get castSpellDamageSummaryEachCreature =>
      'Summe Schaden an jede Kreatur';

  @override
  String get castSpellDamageSummaryEachOpponentCreatures =>
      'Summe Schaden an Kreaturen jedes Gegners';

  @override
  String get cardInfoShortLabelLabel => 'Kurzform (DE)';

  @override
  String get cardInfoShortLabelEnLabel => 'Kurzform (EN)';

  @override
  String get cardInfoEffectDescriptionLabel => 'Effektbeschreibung';

  @override
  String get cardInfoEditEffects => 'Effekte bearbeiten';

  @override
  String get cardInfoAddEffect => 'Effekt hinzufügen';

  @override
  String get castSpell => 'Spielen';

  @override
  String get castSpellSectionReplacement => 'Replacement-Effekte';

  @override
  String get castSpellSectionReplacementHint =>
      'Verändern Schadenswerte auf allen Ebenen (eigener Effekt, ausgelöste Effekte, Folgeeffekte), falls die Bedingung passt (z.B. nur rote Quellen). Zuerst berücksichtigen.';

  @override
  String get castSpellSectionOwnEffect => 'Eigener Effekt';

  @override
  String get castSpellSectionCast => 'Ausgelöste Effekte auf anderen Karten';

  @override
  String get castSpellSectionCastHint =>
      'Effekte anderer Karten im Spiel, die ausgelöst werden, wenn dieser Spruch gespielt wird.';

  @override
  String get followUpHint => 'Eventuelle Folgeeffekte beachten';

  @override
  String get castSpellSectionFollowUp => 'Folgeeffekte';

  @override
  String get castSpellSectionDamageHint =>
      'Falls der Spruch oder einer der obigen Effekte Noncombat-Schaden an einen Gegner verursacht hat, triggert dies.';

  @override
  String get castSpellSectionSpellDamageHint =>
      'Falls der Spruch Schaden an eine Kreatur oder ein Permanent verursacht hat, triggert dies.';

  @override
  String get cardInfoNoData => 'Noch keine weiteren Daten vorhanden.';

  @override
  String get cardTypeCreature => 'Kreatur';

  @override
  String get cardTypeArtifact => 'Artefakt';

  @override
  String get cardTypeInstant => 'Spontanzauber';

  @override
  String get cardTypeSorcery => 'Hexerei';

  @override
  String get cardTypeLand => 'Land';

  @override
  String get cardTypeEnchantment => 'Verzauberung';

  @override
  String get cardTypePlaneswalker => 'Planeswalker';

  @override
  String get sortTooltip => 'Sortierung';

  @override
  String get sortAlphabetical => 'Alphabetisch';

  @override
  String get sortByType => 'Nach Typ';

  @override
  String get sortByTypeCmc => 'Nach Typ / Mana';

  @override
  String get sortByTypeAlpha => 'Nach Typ / Alphabet';

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
  String get noActiveTriggers =>
      'Keine im Spiel befindlichen Karten haben Effekte.';

  @override
  String get actionSave => 'Speichern';

  @override
  String get roundReset => 'Neue Runde';

  @override
  String get roundResetConfirm => 'Alle Karten zurück auf die Hand?';

  @override
  String get cardRatingTitle => 'Bewertung';

  @override
  String get cardRatingNone => 'Nicht bewertet';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get effectSuggestionTitle => 'Erkannte Effekte';

  @override
  String get effectSuggestionHint =>
      'Effekte aus dem Kartentext prüfen und speichern. Nicht passende einfach abwählen.';

  @override
  String effectSuggestionSave(int count) {
    return 'Auswahl speichern ($count)';
  }

  @override
  String get effectSuggestionSelectAll => 'Alle auswählen';

  @override
  String get effectSuggestionDeselectAll => 'Alle abwählen';

  @override
  String get effectSuggestionNone => 'Keine neuen Effekte erkannt.';
}
