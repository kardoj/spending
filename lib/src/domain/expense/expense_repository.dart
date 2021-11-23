import 'package:decimal/decimal.dart';
import 'package:spending/src/domain/expense/expense.dart';
import 'package:spending/src/domain/expense_category/expense_category.dart';
import 'package:spending/src/infrastructure/database_provider.dart';
import 'package:spending/src/infrastructure/repository.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseRepository extends Repository {
  final Database _database;

  static ExpenseRepository? _instance;

  ExpenseRepository._(this._database);

  static Future<ExpenseRepository> getInstance() async {
    final database = await DatabaseProvider.getInstance();
    return _instance ??= ExpenseRepository._(database);
  }

  Future<void> create(Decimal amount, int expenseCategoryId, DateTime occurredOn) async {
    await _database.insert(Expense.tableName, {
      Expense.amountFieldName: saveDecimal(amount),
      Expense.expenseCategoryIdFieldName: expenseCategoryId,
      Expense.occurredOnFieldName: saveDateTime(occurredOn),
      Expense.createdAtFieldName: saveDateTime(DateTime.now())
    });
  }

  Future<Expense?> find(int id) async {
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
        ' where expense_id = ?', [id]);

    if (results.isEmpty) {
      return null;
    }

    return _mapSingle(results.single);
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

    return results.map((result) => _mapSingle(result)).toList();
  }

  Future<void> delete(int id) async {
    await _database.delete(Expense.tableName, where: '${Expense.idFieldName} = ?', whereArgs: [id]);
  }

  Future<void> split(int id, int splitExpenseCategoryId, Decimal splitExpenseAmount) async {
    final expense = (await find(id))!;
    if (splitExpenseAmount >= expense.amount) {
      throw ArgumentError('Split amount must be less than ${expense.amount}.');
    }

    _database.transaction((tx) async {
      await tx.insert(Expense.tableName, {
        Expense.amountFieldName: saveDecimal(splitExpenseAmount),
        Expense.expenseCategoryIdFieldName: splitExpenseCategoryId,
        Expense.occurredOnFieldName: saveDateTime(expense.occurredOn),
        Expense.createdAtFieldName: saveDateTime(DateTime.now())
      });

      await tx.update(
          Expense.tableName,
          { Expense.amountFieldName: saveDecimal(expense.amount - splitExpenseAmount) },
          where: '${Expense.idFieldName} = ?',
          whereArgs: [expense.id]);
    });
  }

  Expense _mapSingle(Map<String, Object?> result) {
    return Expense(
        result['expense_id'] as int,
        readDecimal(result['expense_amount'] as String),
        ExpenseCategory(
            result['expense_category_id'] as int,
            result['expense_category_name'] as String),
        readDateTime(result['expense_occurred_on'] as int),
        readDateTime(result['expense_created_at'] as int));
  }
}