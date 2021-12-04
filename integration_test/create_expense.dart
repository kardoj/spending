import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:spending/src/main.dart' as app;

const _expenseCategoryInputKey = ValueKey('create-expense-category-input');
const _amountInputKey = ValueKey('create-expense-amount-input');
const _occurredOnInputKey = ValueKey('create-expense-occurred-on-input');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetController.hitTestWarningShouldBeFatal = true;

  group('create-expense', () {
    testWidgets('all expense categories are displayed', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      const defaultCategory = 'Food';
      final allCategories = [
        'Lunch', 'Home', 'Car', 'Fuel', 'Hobbies', 'Entertainment', 'Health', 'Alcohol', 'Bills'
      ];

      for (var category in allCategories) {
        expect(find.text(category), category == defaultCategory ? findsOneWidget : findsNothing);
      }

      await tester.tap(find.byKey(_expenseCategoryInputKey));
      await tester.pumpAndSettle();

      expect(find.text(defaultCategory), findsOneWidget);
      for (var category in allCategories) {
        expect(find.text(category), findsOneWidget);
      }
    });

    testWidgets('amount is required', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Amount is required'), findsOneWidget);
    });

    testWidgets('occurred on is required', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(_occurredOnInputKey));
      await tester.pumpAndSettle();

      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Amount is required'), findsOneWidget);
    });

    testWidgets('new expense can be created', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Would like to open category dropdown and select another category,
      // but tapping on dropdown items seems to be broken atm. So just use the default.

      // 'Food' category is pre-selected.
      // TODO: Try to select category to see if it's fixed.

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
      // TODO: This month test will be broken in January because then it needs a padded 0.
      expect(find.text('12.${today.month}.${today.year}'), findsOneWidget);
    });
  });
}