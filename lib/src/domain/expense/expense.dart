import 'package:decimal/decimal.dart';
import 'package:spending/src/domain/entity.dart';

class Expense extends Entity {
  final Decimal amount;
  final int expenseCategoryId;
  final DateTime occurredOn;
  final DateTime createdAt;

  Expense(int id, this.amount, this.expenseCategoryId, this.occurredOn, this.createdAt)
      : super(id);

  static const String tableName = 'expense';

  static const String idFieldName = 'id';
  static const String amountFieldName = 'amount';
  static const String expenseCategoryIdFieldName = 'expense_category_id';
  static const String occurredOnFieldName = 'occurred_on';
  static const String createdAtFieldName = 'created_at';

  static String createTableSql() {
    return 'create table expense ('
        'id integer primary key autoincrement,'
        'amount text not null,'
        'expense_category_id integer not null,'
        'occurred_on int not null,'
        'created_at int not null,'
        'foreign key (expense_category_id) references expense_category(id)'
        ')';
  }
}