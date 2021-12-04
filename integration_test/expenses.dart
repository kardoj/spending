import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:spending/src/main.dart' as app;

const _amountInputKey = ValueKey('create-expense-amount-input');
const _occurredOnInputKey = ValueKey('create-expense-occurred-on-input');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetController.hitTestWarningShouldBeFatal = true;

  group('expenses', () {
    testWidgets('only current month\'s expenses are displayed', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add previous month's expense.
      await tester.enterText(find.byKey(_amountInputKey), '921.59');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(_occurredOnInputKey));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();

      await tester.tap(find.text('12'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Add this month's expense.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(_amountInputKey), '971.59');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(_occurredOnInputKey));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();

      await tester.tap(find.text('12'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Add next month's expense.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(_amountInputKey), '991.59');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(_occurredOnInputKey));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();

      await tester.tap(find.text('12'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final today = DateTime.now();
      expect(find.text('971.59'), findsOneWidget);
      expect(find.text('12.${today.month}.${today.year}'), findsOneWidget);

      expect(find.text('921.59'), findsNothing);

      expect(find.text('991.59'), findsNothing);
    });
  });
}