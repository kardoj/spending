import 'package:decimal/decimal.dart';
import 'package:spending/src/domain/expense/expense.dart';
import 'package:spending/src/domain/expense_category/expense_category.dart';
import 'package:spending/src/infrastructure/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseRepository {
  final Database _database;

  static ExpenseRepository? _instance;

  ExpenseRepository._(this._database);

  static Future<ExpenseRepository> getInstance() async {
    final database = await DatabaseProvider.getInstance();
    return _instance ??= ExpenseRepository._(database);
  }

  Future<void> create(Decimal amount, int expenseCategoryId, DateTime occurredOn) async {
    await _database.insert(Expense.tableName, {
      Expense.amountFieldName: amount.toString(),
      Expense.expenseCategoryIdFieldName: expenseCategoryId,
      Expense.occurredOnFieldName: occurredOn.millisecondsSinceEpoch,
      Expense.createdAtFieldName: DateTime.now().millisecondsSinceEpoch // TODO: Should be in UTC? MillisecondsSinceEpoch should be in a helper? Base class helper?
    });
  }

  Future<List<Expense>> getAll() async {
    final results = await _database.rawQuery(
      ' select '
        ' ${Expense.tableName}.${Expense.idFieldName} as expense_id, '
        ' ${Expense.tableName}.${Expense.amountFieldName} as expense_amount, '
        ' ${Expense.tableName}.${Expense.occurredOnFieldName} as expense_occurred_on, '
        ' ${Expense.tableName}.${Expense.createdAtFieldName} as expense_created_at, '
        ' ${ExpenseCategory.tableName}.${ExpenseCategory.idFieldName} as expense_category_id, '
        ' ${ExpenseCategory.tableName}.${ExpenseCategory.nameFieldName} as expense_category_name '
      ' from ${Expense.tableName} '
      ' inner join ${ExpenseCategory.tableName} '
      ' on ${ExpenseCategory.tableName}.${ExpenseCategory.idFieldName}=${Expense.tableName}.${Expense.expenseCategoryIdFieldName} '
      ' order by expense_occurred_on desc, expense_id desc '
    );

    return results.map((result) => Expense(
      result['expense_id'] as int,
      Decimal.parse(result['expense_amount'] as String),
      ExpenseCategory(
        result['expense_category_id'] as int,
        result['expense_category_name'] as String),
      DateTime.fromMillisecondsSinceEpoch(result['expense_occurred_on'] as int),
      DateTime.fromMillisecondsSinceEpoch(result['expense_created_at'] as int))).toList();
  }
}