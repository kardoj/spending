import 'package:spending/src/domain/expense_category/expense_category.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseCategoryRepository {
  final Database _database;

  ExpenseCategoryRepository(this._database);

  Future<List<ExpenseCategory>> getAll() async {
    final results = await _database
        .rawQuery('select * from ' + ExpenseCategory.tableName + ' order by ' + ExpenseCategory.nameFieldName + ' asc');

    return results.map((result) => ExpenseCategory(
        result[ExpenseCategory.idFieldName] as int,
        result[ExpenseCategory.nameFieldName] as String)).toList();
  }
}