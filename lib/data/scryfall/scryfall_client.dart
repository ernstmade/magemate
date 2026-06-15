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

  factory ScryfallCard.fromJson(Map<String, dynamic> json) {
    // Bei doppelseitigen Karten stehen Mana-Kosten/Text oft nur auf der
    // ersten "card_face" statt auf der obersten Ebene.
    final faces = json['card_faces'] as List<dynamic>?;
    final firstFace = faces != null && faces.isNotEmpty
        ? faces.first as Map<String, dynamic>
        : null;

    String? str(String key) =>
        (json[key] ?? firstFace?[key]) as String?;

    final colors = (json['colors'] ?? firstFace?['colors']) as List<dynamic>?;
    final imageUris = (json['image_uris'] ?? firstFace?['image_uris'])
        as Map<String, dynamic>?;

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
    );
  }
}

/// Minimaler Client für die öffentliche Scryfall-API (keine Authentifizierung
/// nötig). https://scryfall.com/docs/api
class ScryfallClient {
  static const _baseUrl = 'https://api.scryfall.com';
  static const _batchSize = 75;

  /// Lädt Karteninfos für die übergebenen (Set, Sammelnummer)-Paare per
  /// Collection-Endpoint (max. 75 Identifier pro Anfrage).
  Future<List<ScryfallCard>> fetchCards(
    List<(String setCode, String collectorNumber)> identifiers,
  ) async {
    final results = <ScryfallCard>[];
    for (var i = 0; i < identifiers.length; i += _batchSize) {
      final batch = identifiers.skip(i).take(_batchSize).toList();
      final response = await http.post(
        Uri.parse('$_baseUrl/cards/collection'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'MagicSupportApp/1.0',
        },
        body: jsonEncode({
          'identifiers': [
            for (final (setCode, collectorNumber) in batch)
              {'set': setCode.toLowerCase(), 'collector_number': collectorNumber},
          ],
        }),
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Scryfall-Anfrage fehlgeschlagen (${response.statusCode})',
        );
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final found = data['data'] as List<dynamic>;
      for (final card in found) {
        results.add(ScryfallCard.fromJson(card as Map<String, dynamic>));
      }
    }
    return results;
  }
}
