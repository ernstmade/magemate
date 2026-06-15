import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Aktuell für den "Spiel"-Tab ausgewähltes Deck. null = keins ausgewählt.
final activeDeckProvider = StateProvider<int?>((ref) => null);
