import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.settingsLanguage),
            trailing: DropdownButton<Locale?>(
              value: locale,
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.settingsLanguageSystem),
                ),
                const DropdownMenuItem(
                  value: Locale('de'),
                  child: Text('Deutsch'),
                ),
                const DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
              ],
              onChanged: (value) =>
                  ref.read(localeProvider.notifier).state = value,
            ),
          ),
        ],
      ),
    );
  }
}
