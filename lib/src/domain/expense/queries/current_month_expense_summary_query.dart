import 'package:decimal/decimal.dart';
import 'package:spending/src/domain/expense/expense_repository.dart';
import 'package:spending/src/domain/expense_category/expense_category.dart';

class CurrentMonthExpenseSummaryQuery {
  final ExpenseRepository _expenseRepository;

  CurrentMonthExpenseSummaryQuery(this._expenseRepository);

  Future<List<ExpenseSummaryItem>> execute() async {
    final expenses = await _expenseRepository.getCurrentMonth();
    if (expenses.isEmpty) {
      return List.empty();
    }

    var summedExpenses = <int, Decimal>{};
    var categoryMap = <int, ExpenseCategory>{};
    for (var expense in expenses) {
      var key = expense.expenseCategory.id;

      if (!summedExpenses.containsKey(key)) {
        summedExpenses[key] = expense.amount;
        categoryMap[key] = expense.expenseCategory;
      } else {
        summedExpenses[key] = summedExpenses[key]! + expense.amount;
      }
    }

    return summedExpenses.entries.map((e) => ExpenseSummaryItem(e.value, categoryMap[e.key]!)).toList();
  }
}

class ExpenseSummaryItem {
  final Decimal _amount;
  final ExpenseCategory _expenseCategory;

  Decimal get amount => _amount;
  ExpenseCategory get expenseCategory => _expenseCategory;

  ExpenseSummaryItem(this._amount, this._expenseCategory);
}