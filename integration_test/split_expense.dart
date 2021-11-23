import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:spending/src/main.dart' as app;

const _createExpenseAmountInputKey = ValueKey('create-expense-amount-input');
const _createExpenseOccurredOnInputKey = ValueKey('create-expense-occurred-on-input');
const _splitExpenseAmountInputKey = ValueKey('split-expense-amount-input');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetController.hitTestWarningShouldBeFatal = true;

  group('split-expense', () {
    testWidgets('part of expense can be split to another expense', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(_createExpenseAmountInputKey), '971.59');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(_createExpenseOccurredOnInputKey));
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

      await tester.tap(find.byIcon(Icons.splitscreen_outlined));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(_splitExpenseAmountInputKey), '171.59');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('800.00'), findsOneWidget);
      expect(find.text('171.59'), findsOneWidget);
      expect(find.text('Food'), findsNWidgets(2));
      expect(find.text('12.${today.month}.${today.year}'), findsNWidgets(2));

      // Delete expenses for clean page for the next test.
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('DELETE'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.text('DELETE'));
      await tester.pumpAndSettle();
    });

    testWidgets('expense is not split if split is canceled', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(_createExpenseAmountInputKey), '971.59');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(_createExpenseOccurredOnInputKey));
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

      await tester.tap(find.byIcon(Icons.splitscreen_outlined));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(_splitExpenseAmountInputKey), '171.59');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('971.59'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('12.${today.month}.${today.year}'), findsOneWidget);
    });
  });
}