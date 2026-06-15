import 'package:flutter/material.dart';

/// Hintergrundfarbe für ein einzelnes Mana-Symbol (z.B. "R", "2", "W/U").
Color manaSymbolColor(String symbol) {
  switch (symbol.toUpperCase()) {
    case 'W':
      return const Color(0xFFF8F6D8);
    case 'U':
      return const Color(0xFF0E68AB);
    case 'B':
      return const Color(0xFF150B00);
    case 'R':
      return const Color(0xFFD3202A);
    case 'G':
      return const Color(0xFF00733E);
    case 'C':
      return const Color(0xFFCAC5C0);
    default:
      // Zahlen, X, Hybrid- oder Phyrexian-Mana etc.
      return const Color(0xFFBEB9B2);
  }
}

Color _manaSymbolTextColor(String symbol) {
  switch (symbol.toUpperCase()) {
    case 'W':
      return Colors.black;
    case 'B':
      return Colors.white;
    default:
      return Colors.black;
  }
}

/// Stellt ein einzelnes Mana-Symbol als kleinen farbigen Kreis dar.
class ManaSymbol extends StatelessWidget {
  const ManaSymbol({super.key, required this.symbol, this.size = 20});

  final String symbol;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.only(left: 2),
      decoration: BoxDecoration(
        color: manaSymbolColor(symbol),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        symbol,
        style: TextStyle(
          fontSize: size * 0.55,
          fontWeight: FontWeight.bold,
          color: _manaSymbolTextColor(symbol),
        ),
      ),
    );
  }
}

/// Parst eine Scryfall-Manakosten-Zeichenkette wie "{2}{R}{R}" in einzelne
/// Symbole ("2", "R", "R") und stellt sie als Kreise dar.
class ManaCostIcons extends StatelessWidget {
  const ManaCostIcons({super.key, required this.manaCost, this.size = 20});

  final String manaCost;
  final double size;

  @override
  Widget build(BuildContext context) {
    final symbols = RegExp(
      r'\{([^}]+)\}',
    ).allMatches(manaCost).map((m) => m.group(1)!).toList();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final symbol in symbols) ManaSymbol(symbol: symbol, size: size),
      ],
    );
  }
}

/// Stellt die Farbidentität einer Karte als kleinen Kreis dar. Bei mehreren
/// Farben werden diese als Segmente angezeigt, bei keiner Farbe ein grauer
/// Kreis (farblos).
class ColorIdentityDot extends StatelessWidget {
  const ColorIdentityDot({super.key, required this.colors, this.size = 24});

  final String? colors;
  final double size;

  @override
  Widget build(BuildContext context) {
    final parsed = (colors ?? '')
        .split(',')
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toList();

    if (parsed.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: manaSymbolColor('C'),
          shape: BoxShape.circle,
        ),
      );
    }

    if (parsed.length == 1) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: manaSymbolColor(parsed.first),
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Column(
        children: [
          for (final color in parsed)
            Expanded(child: Container(color: manaSymbolColor(color))),
        ],
      ),
    );
  }
}
