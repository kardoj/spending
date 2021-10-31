import 'package:decimal/decimal.dart';
import 'package:spending/src/domain/expense/expense.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseRepository {
  final Database _database;

  ExpenseRepository(this._database);

  Future<void> create(Decimal amount, int expenseCategoryId, DateTime occurredAt) async {
    await _database.insert(Expense.tableName, {
      Expense.amountFieldName: amount.toString(),
      Expense.expenseCategoryIdFieldName: expenseCategoryId,
      Expense.occurredAtFieldName: occurredAt.millisecondsSinceEpoch,
      Expense.createdAtFieldName: DateTime.now().millisecondsSinceEpoch // TODO: Should be in UTC? MillisecondsSinceEpoch should be in a helper? Base class helper?
    });
  }

  Future<Expense?> get(int id) async {
    final results = await _database.rawQuery('select * from ' + Expense.tableName + ' where id = ?', [id]);
    if (results.isEmpty) {
      return null;
    }

    final expenseData = results.single;
    return Expense(
      expenseData[Expense.idFieldName] as int,
      Decimal.parse(expenseData[Expense.amountFieldName] as String),
      expenseData[Expense.expenseCategoryIdFieldName] as int,
      DateTime.fromMillisecondsSinceEpoch(expenseData[Expense.occurredAtFieldName] as int),
      DateTime.fromMillisecondsSinceEpoch(expenseData[Expense.createdAtFieldName] as int),
    );
  }
}