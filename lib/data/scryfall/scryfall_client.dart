import 'dart:convert';
import 'package:http/http.dart' as http;

/// Eine einzelne Karteninfo, wie sie von Scryfall zurückgegeben wird.
class ScryfallCard {
  const ScryfallCard({
    required this.setCode,
    required this.collectorNumber,
    required this.scryfallId,
    this.manaCost,
    this.cmc,
    this.typeLine,
    this.oracleText,
    this.colors,
    this.power,
    this.toughness,
    this.imageUri,
    this.keywords,
    this.printedName,
    this.printedText,
    this.printedTypeLine,
  });

  final String setCode;
  final String collectorNumber;
  final String scryfallId;
  final String? manaCost;
  final double? cmc;
  final String? typeLine;
  final String? oracleText;
  final String? colors;
  final String? power;
  final String? toughness;
  final String? imageUri;
  /// Schlüsselwörter kommagetrennt, z.B. "Flying,Trample". Null wenn leer.
  final String? keywords;
  /// Lokalisierter Kartenname (z.B. Deutsch), null wenn nicht verfügbar.
  final String? printedName;
  /// Lokalisierter Regeltext (z.B. Deutsch), null wenn nicht verfügbar.
  final String? printedText;
  /// Lokalisierter Typ (z.B. Deutsch), null wenn nicht verfügbar.
  final String? printedTypeLine;

  factory ScryfallCard.fromJson(Map<String, dynamic> json) {
    final faces = json['card_faces'] as List<dynamic>?;
    final firstFace = faces != null && faces.isNotEmpty
        ? faces.first as Map<String, dynamic>
        : null;

    String? str(String key) =>
        (json[key] ?? firstFace?[key]) as String?;

    final colors = (json['colors'] ?? firstFace?['colors']) as List<dynamic>?;
    final imageUris = (json['image_uris'] ?? firstFace?['image_uris'])
        as Map<String, dynamic>?;
    final keywords = json['keywords'] as List<dynamic>?;

    return ScryfallCard(
      setCode: (json['set'] as String).toUpperCase(),
      collectorNumber: json['collector_number'] as String,
      scryfallId: json['id'] as String,
      manaCost: str('mana_cost'),
      cmc: (json['cmc'] as num?)?.toDouble(),
      typeLine: str('type_line'),
      oracleText: str('oracle_text'),
      colors: colors?.join(','),
      power: str('power'),
      toughness: str('toughness'),
      imageUri: imageUris?['normal'] as String?,
      keywords: (keywords != null && keywords.isNotEmpty)
          ? keywords.map((k) => k.toString()).join(',')
          : null,
      // printed_* nur bei lokalisierten Einzelabrufen vorhanden
      printedName: str('printed_name'),
      printedText: str('printed_text'),
      printedTypeLine: str('printed_type_line'),
    );
  }

  /// Gibt eine Kopie mit den lokalisierten Feldern aus [localized] zurück.
  ScryfallCard withLocalized(ScryfallCard localized) {
    return ScryfallCard(
      setCode: setCode,
      collectorNumber: collectorNumber,
      scryfallId: scryfallId,
      manaCost: manaCost,
      cmc: cmc,
      typeLine: typeLine,
      oracleText: oracleText,
      colors: colors,
      power: power,
      toughness: toughness,
      imageUri: imageUri,
      keywords: keywords,
      printedName: localized.printedName,
      printedText: localized.printedText,
      printedTypeLine: localized.printedTypeLine,
    );
  }
}

/// Minimaler Client für die öffentliche Scryfall-API (keine Authentifizierung
/// nötig). https://scryfall.com/docs/api
class ScryfallClient {
  static const _baseUrl = 'https://api.scryfall.com';
  static const _batchSize = 75;

  /// Lädt Karteninfos für die übergebenen (Set, Sammelnummer)-Paare.
  ///
  /// Schritt 1: Batch-Abruf aller Karten auf Englisch via /cards/collection.
  /// Schritt 2: Für jede gefundene Karte individueller Abruf auf [localeLang]
  /// (Standard: "de"). Karten ohne lokalisierte Version behalten nur den
  /// englischen Text. Zwischen den Einzelabrufen wird kurz gewartet, um
  /// Scryfall-Rate-Limits zu respektieren.
  Future<List<ScryfallCard>> fetchCards(
    List<(String setCode, String collectorNumber)> identifiers, {
    String localeLang = 'de',
    void Function(int done, int total, String cardName)? onProgress,
  }) async {
    // Schritt 1: Englische Basisdaten per Batch laden
    final baseCards = <ScryfallCard>[];
    for (var i = 0; i < identifiers.length; i += _batchSize) {
      final batch = identifiers.skip(i).take(_batchSize).toList();
      final found = await _fetchBatch(batch);
      baseCards.addAll(found);
    }

    // Schritt 2: Deutsche Texte per Einzelabruf nachladen
    final results = <ScryfallCard>[];
    for (var i = 0; i < baseCards.length; i++) {
      final card = baseCards[i];
      final localized = await _fetchLocalized(
        card.setCode,
        card.collectorNumber,
        localeLang,
      );
      final result = localized != null ? card.withLocalized(localized) : card;
      results.add(result);
      onProgress?.call(i + 1, baseCards.length, result.printedName ?? result.scryfallId);
      // Scryfall erlaubt ~10 Anfragen/Sekunde
      await Future<void>.delayed(const Duration(milliseconds: 120));
    }
    return results;
  }

  /// Lädt einen Batch via POST /cards/collection (keine Sprachunterstützung).
  Future<List<ScryfallCard>> _fetchBatch(
    List<(String setCode, String collectorNumber)> batch,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cards/collection'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'MagemateApp/1.0',
      },
      body: jsonEncode({
        'identifiers': [
          for (final (setCode, collectorNumber) in batch)
            {
              'set': setCode.toLowerCase(),
              'collector_number': collectorNumber,
            },
        ],
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Scryfall-Anfrage fehlgeschlagen (${response.statusCode})',
      );
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['data'] as List<dynamic>)
        .map((c) => ScryfallCard.fromJson(c as Map<String, dynamic>))
        .toList();
  }

  /// Lädt eine einzelne Karte in [lang] via GET /cards/{set}/{number}/{lang}.
  /// Gibt null zurück wenn keine lokalisierte Version existiert (404).
  Future<ScryfallCard?> _fetchLocalized(
    String setCode,
    String collectorNumber,
    String lang,
  ) async {
    final url = Uri.parse(
      '$_baseUrl/cards/${setCode.toLowerCase()}/$collectorNumber/$lang',
    );
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'MagemateApp/1.0',
      },
    );
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      // Fehler beim Einzelabruf ignorieren, englische Version bleibt
      return null;
    }
    return ScryfallCard.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
