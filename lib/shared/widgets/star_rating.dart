import 'package:flutter/material.dart';

/// Zeigt eine Sternebewertung (0–5,5 in 0,25-Schritten) als Icon-Reihe.
/// Maximal 5 Sterne + optionaler halber Stern (bei Werten > 5).
///
/// Füll-Logik pro Stern (Index 0–4):
///   - vollständig gefüllt  → rating ≥ index + 1
///   - halb gefüllt         → rating ≥ index + 0.5 und rating < index + 1
///   - leer                 → rating < index + 0.5
///
/// Werte über 5 (5.25 und 5.5) werden als 5 volle Sterne + halber/voller
/// "Bonus"-Stern rechts davon angezeigt.
class StarRatingDisplay extends StatelessWidget {
  const StarRatingDisplay({
    super.key,
    required this.rating,
    this.size = 20,
    this.color,
  });

  final double rating;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final starColor =
        color ?? Theme.of(context).colorScheme.primary;

    // Hauptsterne (0–5)
    final baseStar = rating.clamp(0, 5).toDouble();
    final stars = List.generate(5, (i) {
      final threshold = i + 1.0;
      if (baseStar >= threshold) return Icons.star;
      if (baseStar >= threshold - 0.5) return Icons.star_half;
      return Icons.star_border;
    });

    // Bonus-Stern für Werte 5.25 und 5.5
    IconData? bonusStar;
    if (rating >= 5.5) {
      bonusStar = Icons.star_half;
    } else if (rating >= 5.25) {
      bonusStar = Icons.star_border; // Viertelschritt: kein halber Stern
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final icon in stars)
          Icon(icon, size: size, color: starColor),
        if (bonusStar != null)
          Icon(bonusStar, size: size, color: starColor),
      ],
    );
  }
}
