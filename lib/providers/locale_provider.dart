import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// null = Systemsprache, 'de' = Deutsch, 'en' = Englisch
final localeProvider = StateProvider<Locale?>((ref) => null);
