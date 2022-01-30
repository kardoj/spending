import 'package:spending/src/domain/expense_category/expense_category.dart';
import 'package:sqflite/sqflite.dart';

import 'migration.dart';

class AddClothesExpenseCategory extends Migration {
  @override
  Future<void> down(Database database) {
    throw UnimplementedError();
  }

  @override
  Future<void> up(Database database) async {
    await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Clothes' });
  }
}