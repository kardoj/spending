import 'package:decimal/decimal.dart';
import 'package:spending/src/domain/entity.dart';
import 'package:spending/src/domain/expense_category/expense_category.dart';

class Expense extends Entity {
  final Decimal amount;
  final ExpenseCategory expenseCategory;
  final DateTime occurredOn;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;

  Expense(int id, this.amount, this.expenseCategory, this.occurredOn, this.createdAt, this.latitude, this.longitude)
      : super(id);

  static const String tableName = 'expense';

  static const String idFieldName = 'id';
  static const String amountFieldName = 'amount';
  static const String expenseCategoryIdFieldName = 'expense_category_id';
  static const String occurredOnFieldName = 'occurred_on';
  static const String createdAtFieldName = 'created_at';
  static const String latitudeFieldName = 'latitude';
  static const String longitudeFieldName = 'longitude';
}