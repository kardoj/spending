import 'package:decimal/decimal.dart';
import 'package:spending/src/domain/entity.dart';
import 'package:spending/src/domain/expense_category/expense_category.dart';

class Expense extends Entity {
  final Decimal amount;
  final ExpenseCategory expenseCategory;
  final DateTime occurredOn;
  final DateTime createdAt;

  Expense(int id, this.amount, this.expenseCategory, this.occurredOn, this.createdAt)
      : super(id);

  static const String tableName = 'expense';

  static const String idFieldName = 'id';
  static const String amountFieldName = 'amount';
  static const String expenseCategoryIdFieldName = 'expense_category_id';
  static const String occurredOnFieldName = 'occurred_on';
  static const String createdAtFieldName = 'created_at';

  static String createTableSql() {
    return 'create table $tableName ('
        '$idFieldName integer primary key autoincrement,'
        '$amountFieldName text not null,'
        '$expenseCategoryIdFieldName integer not null,'
        '$occurredOnFieldName int not null,'
        '$createdAtFieldName int not null,'
        'foreign key ($expenseCategoryIdFieldName) references ${ExpenseCategory.tableName}(${ExpenseCategory.idFieldName})'
        ')';
  }
}