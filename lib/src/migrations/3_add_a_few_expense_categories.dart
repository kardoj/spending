import 'package:spending/src/domain/expense_category/expense_category.dart';
import 'package:sqflite/sqflite.dart';

import 'migration.dart';

class AddAFewExpenseCategories extends Migration {
  @override
  Future<void> down(Database database) {
    throw UnimplementedError();
  }

  @override
  Future<void> up(Database database) async {
    await database.transaction((tx) async {
      await tx.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Transportation' });
      await tx.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Gift' });
      await tx.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Parking' });
    });
  }
}