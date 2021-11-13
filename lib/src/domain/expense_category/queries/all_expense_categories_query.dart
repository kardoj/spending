import 'package:spending/src/domain/expense_category/expense_category.dart';
import 'package:spending/src/domain/expense_category/expense_category_repository.dart';
import 'package:spending/src/infrastructure/queries/query.dart';
import 'package:spending/src/infrastructure/queries/query_handler.dart';

class AllExpenseCategoriesQuery extends Query<List<ExpenseCategory>> {
}

class AllExpenseCategoriesQueryHandler implements QueryHandler<AllExpenseCategoriesQuery, List<ExpenseCategory>> {
  final ExpenseCategoryRepository _repository;

  AllExpenseCategoriesQueryHandler(this._repository);

  @override
  Future<List<ExpenseCategory>> handle(Query<List<ExpenseCategory>> query) async {
    return await _repository.getAll();
  }
}