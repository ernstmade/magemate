/// Eine Zeile einer Deckliste, z.B. "4 Lightning Bolt (CLU) 141".
class ParsedCard {
  const ParsedCard({
    required this.quantity,
    required this.name,
    required this.setCode,
    required this.collectorNumber,
    required this.board,
  });

  final int quantity;
  final String name;
  final String? setCode;
  final String? collectorNumber;

  /// 'main' | 'side' | 'maybe'
  final String board;
}

/// Parst Decklisten im Format
/// "`<Anzahl> <Name> (<Set>) <Collector-Nr.>`" mit optionalen Abschnitten
/// "// SIDEBOARD" und "// MAYBEBOARD".
List<ParsedCard> parseDeckList(String content) {
  final lineRegex = RegExp(
    r'^(\d+)\s+(.+?)\s+\(([A-Za-z0-9]+)\)\s+(\S+)',
  );

  var board = 'main';
  final result = <ParsedCard>[];

  for (final rawLine in content.split('\n')) {
    final line = rawLine.trim();
    if (line.isEmpty) continue;

    if (line.startsWith('//')) {
      final section = line.replaceFirst('//', '').trim().toLowerCase();
      if (section.contains('sideboard')) {
        board = 'side';
      } else if (section.contains('maybeboard')) {
        board = 'maybe';
      }
      continue;
    }

    final match = lineRegex.firstMatch(line);
    if (match == null) continue;

    result.add(
      ParsedCard(
        quantity: int.parse(match.group(1)!),
        name: match.group(2)!,
        setCode: match.group(3),
        collectorNumber: match.group(4),
        board: board,
      ),
    );
  }

  return result;
}
