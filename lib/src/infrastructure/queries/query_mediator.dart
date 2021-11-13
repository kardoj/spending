import 'package:spending/src/domain/expense/expense.dart';
import 'package:spending/src/domain/expense/expense_repository.dart';
import 'package:spending/src/domain/expense/queries/all_expenses_query.dart';
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
    // TODO: See ei tundu vist hea, et repository sõltuvus on andmebaas? Reedab implementatsiooni?
    final expenseCategoryRepository = ExpenseCategoryRepository(_database);
    return await AllExpenseCategoriesQueryHandler(expenseCategoryRepository).handle(query);
  }

  // TODO: Mis teha sellega, et overloade ei saa olla? Võib-olla on kogu see queryde ja commandide teema siis mõttetu? Kasutaks otse repositoryt?
  Future<List<Expense>> send2(AllExpensesQuery query) async {
    final expenseRepository = ExpenseRepository(_database);
    return await AllExpensesQueryHandler(expenseRepository).handle(query);
  }
}