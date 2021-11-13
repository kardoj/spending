import 'package:spending/src/domain/expense_category/expense_category.dart';
import 'package:spending/src/infrastructure/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseCategoryRepository {
  static ExpenseCategoryRepository? _instance;

  final Database _database;

  ExpenseCategoryRepository._(this._database);

  static Future<ExpenseCategoryRepository> getInstance() async {
    final database = await DatabaseProvider.getInstance();
    return _instance ??= ExpenseCategoryRepository._(database);
  }

  Future<List<ExpenseCategory>> getAll() async {
    final results = await _database
        .rawQuery('select * from ' + ExpenseCategory.tableName + ' order by ' + ExpenseCategory.nameFieldName + ' asc');

    return results.map((result) => ExpenseCategory(
        result[ExpenseCategory.idFieldName] as int,
        result[ExpenseCategory.nameFieldName] as String)).toList();
  }
}