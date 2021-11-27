import 'package:decimal/decimal.dart';
import 'package:spending/src/domain/expense/expense.dart';
import 'package:spending/src/domain/expense_category/expense_category.dart';

class TestExpense {
  static Expense create(int? expenseCategoryId, DateTime? createdAt, double? latitude, double? longitude) {
    expenseCategoryId = expenseCategoryId ?? 7;
    createdAt = createdAt ?? DateTime.now().add(const Duration(days: -1400));

    return Expense(
        5,
        Decimal.parse('11.20'),
        ExpenseCategory(expenseCategoryId, "test expense category"),
        DateTime.now().add(const Duration(days: -1300)),
        createdAt,
        latitude,
        longitude);
  }
}