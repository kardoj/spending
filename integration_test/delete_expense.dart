import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:spending/src/main.dart' as app;

const _amountInputKey = ValueKey('create-expense-amount-input');
const _occurredOnInputKey = ValueKey('create-expense-occurred-on-input');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetController.hitTestWarningShouldBeFatal = true;

  group('delete-expense', () {
    testWidgets('expense can be deleted', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add the first.
      await tester.enterText(find.byKey(_amountInputKey), '971.59');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(_occurredOnInputKey));
      await tester.pumpAndSettle();

      await tester.tap(find.text('12'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Add the second.
      await tester.enterText(find.byKey(_amountInputKey), '125.30');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(_occurredOnInputKey));
      await tester.pumpAndSettle();

      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify that both exist.
      final today = DateTime.now();
      expect(find.text('971.59'), findsOneWidget);
      expect(find.text('12.${today.month}.${today.year}'), findsOneWidget);

      expect(find.text('125.30'), findsOneWidget);
      expect(find.text('15.${today.month}.${today.year}'), findsOneWidget);

      expect(find.text('Food'), findsNWidgets(2));

      await tester.tap(find.byIcon(Icons.delete_outline).last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('DELETE'));
      await tester.pumpAndSettle();

      // Verify that only the second one exists after delete.
      expect(find.text('971.59'), findsNothing);
      expect(find.text('12.${today.month}.${today.year}'), findsNothing);

      expect(find.text('125.30'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('15.${today.month}.${today.year}'), findsOneWidget);

      // Delete the other expense for clean page for the next test.
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.text('DELETE'));
      await tester.pumpAndSettle();
    });

    testWidgets('expense is not deleted if delete is canceled', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(_amountInputKey), '971.59');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(_occurredOnInputKey));
      await tester.pumpAndSettle();

      await tester.tap(find.text('12'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final today = DateTime.now();
      expect(find.text('971.59'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('12.${today.month}.${today.year}'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();

      expect(find.text('971.59'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('12.${today.month}.${today.year}'), findsOneWidget);
    });
  });
}