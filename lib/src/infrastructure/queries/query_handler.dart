import 'package:spending/src/infrastructure/queries/query.dart';

abstract class QueryHandler<TQuery extends Query<TResult>, TResult> {
  Future<TResult> handle(Query<TResult> query);
}