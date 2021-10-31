import 'package:decimal/decimal.dart';

class Expense {
  int _id;
  Decimal _amount;
  int _expenseCategoryId;
  DateTime _dateTime;
  DateTime _createdAt;

  Expense(this._id, this._amount, this._expenseCategoryId, this._dateTime, this._createdAt);
}