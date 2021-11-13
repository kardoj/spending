import 'package:spending/src/domain/expense_category/expense_category.dart';
import 'package:spending/src/domain/expense_category/expense_category_repository.dart';
import 'package:spending/src/domain/expense_category/queries/all_expense_categories_query.dart';
import 'package:spending/src/infrastructure/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class QueryMediator {
  final Database _database;

  static QueryMediator? _instance;

  QueryMediator._(this._database);

  static Future<QueryMediator> getInstance() async {
    final database = await DatabaseProvider.provide();
    return _instance ??= QueryMediator._(database);
  }

  Future<List<ExpenseCategory>> send(AllExpenseCategoriesQuery query) async {
    final expenseCategoryRepository = ExpenseCategoryRepository(_database);
    return await AllExpenseCategoriesQueryHandler(expenseCategoryRepository).handle(query);
  }
}