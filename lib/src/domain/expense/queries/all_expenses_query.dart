import 'package:spending/src/domain/expense/expense.dart';
import 'package:spending/src/infrastructure/queries/query.dart';
import 'package:spending/src/infrastructure/queries/query_handler.dart';

import '../expense_repository.dart';

class AllExpensesQuery extends Query<List<Expense>> {
}

class AllExpensesQueryHandler implements QueryHandler<AllExpensesQuery, List<Expense>> {
  final ExpenseRepository _repository;

  AllExpensesQueryHandler(this._repository);

  @override
  Future<List<Expense>> handle(Query<List<Expense>> query) async {
    return await _repository.getAll();
  }
}