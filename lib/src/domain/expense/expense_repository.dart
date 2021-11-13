import 'package:decimal/decimal.dart';
import 'package:spending/src/domain/expense/expense.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseRepository {
  final Database _database;

  ExpenseRepository(this._database);

  Future<void> create(Decimal amount, int expenseCategoryId, DateTime occurredOn) async {
    await _database.insert(Expense.tableName, {
      Expense.amountFieldName: amount.toStringAsFixed(2),
      Expense.expenseCategoryIdFieldName: expenseCategoryId,
      Expense.occurredOnFieldName: occurredOn.millisecondsSinceEpoch,
      Expense.createdAtFieldName: DateTime.now().millisecondsSinceEpoch // TODO: Should be in UTC? MillisecondsSinceEpoch should be in a helper? Base class helper?
    });
  }

  Future<Expense?> get(int id) async {
    final results = await _database.rawQuery('select * from ' + Expense.tableName + ' where id = ?', [id]);
    if (results.isEmpty) {
      return null;
    }

    final result = results.single;
    return Expense(
      result[Expense.idFieldName] as int,
      Decimal.parse(result[Expense.amountFieldName] as String),
      result[Expense.expenseCategoryIdFieldName] as int,
      DateTime.fromMillisecondsSinceEpoch(result[Expense.occurredOnFieldName] as int),
      DateTime.fromMillisecondsSinceEpoch(result[Expense.createdAtFieldName] as int)
    );
  }

  Future<List<Expense>> getAll() async {
    final results = await _database
      .rawQuery('select * from ' + Expense.tableName + ' order by ' + Expense.occurredOnFieldName + ' desc, ' + Expense.idFieldName + ' desc');

    return results.map((result) => Expense(
      result[Expense.idFieldName] as int,
      Decimal.parse(result[Expense.amountFieldName] as String),
      result[Expense.expenseCategoryIdFieldName] as int,
      DateTime.fromMillisecondsSinceEpoch(result[Expense.occurredOnFieldName] as int),
      DateTime.fromMillisecondsSinceEpoch(result[Expense.createdAtFieldName] as int))).toList();
  }
}