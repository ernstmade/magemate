import 'package:flutter/material.dart';

/// Rendert einen MTG-Oracle-Text mit kleinem Abstand zwischen den einzelnen
/// Fähigkeiten (Absätze, getrennt durch '\n').
class OracleText extends StatelessWidget {
  const OracleText(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final paragraphs = text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    if (paragraphs.length <= 1) {
      return Text(text, style: style);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < paragraphs.length; i++) ...[
          if (i > 0) const SizedBox(height: 6),
          Text(paragraphs[i], style: style),
        ],
      ],
    );
  }
}
