import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spending/src/domain/expense/expense.dart';
import 'package:spending/src/domain/expense/expense_repository.dart';
import 'package:spending/src/domain/expense/queries/current_month_expense_summary_query.dart';
import 'package:spending/src/domain/expense_category/expense_category.dart';

import 'recommend_expense_category_query_tests.mocks.dart';

@GenerateMocks([ExpenseRepository])
void main() {
  test('execute returns nothing if there are no registered expenses', () async {
    final repositoryMock = MockExpenseRepository();
    final sut = CurrentMonthExpenseSummaryQuery(repositoryMock);

    final List<Expense> expectedExpenses = [];
    when(repositoryMock.getCurrentMonth())
      .thenAnswer((_) => Future.value(expectedExpenses));

    // Act
    var result = await sut.execute();

    // Assert
    expect(result, []);
  });

  test('execute sums current month expense entries by category', () async {
    final repositoryMock = MockExpenseRepository();
    final sut = CurrentMonthExpenseSummaryQuery(repositoryMock);

    var category1 = ExpenseCategory(1, "Cat 1");
    var category2 = ExpenseCategory(2, "Cat 2");
    final List<Expense> expectedExpenses = [
      Expense(1, Decimal.parse("12.4"), category1, DateTime.now(), DateTime.now(), 1, 2),
      Expense(2, Decimal.parse("3.21"), category2, DateTime.now(), DateTime.now(), 1, 2),
      Expense(3, Decimal.parse("5"), category1, DateTime.now(), DateTime.now(), 1, 2),
      Expense(4, Decimal.parse("4.72"), category2, DateTime.now(), DateTime.now(), 1, 2),
      Expense(5, Decimal.parse("16.34"), category2, DateTime.now(), DateTime.now(), 1, 2),
    ];
    when(repositoryMock.getCurrentMonth())
        .thenAnswer((_) => Future.value(expectedExpenses));

    // Act
    var result = await sut.execute();

    // Assert
    expect(result, hasLength(2));

    expect(result[0].expenseCategory, equals(category1));
    expect(result[0].amount, equals(Decimal.parse("17.4")));

    expect(result[1].expenseCategory, equals(category2));
    expect(result[1].amount, equals(Decimal.parse("24.27")));
  });
}