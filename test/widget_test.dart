import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:magicsupport/data/database/app_database.dart';
import 'package:magicsupport/main.dart';
import 'package:magicsupport/providers/database_provider.dart';

void main() {
  testWidgets('App startet und zeigt Decks-Tab', (WidgetTester tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MagicSupportApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Decks'), findsWidgets);
  });
}
