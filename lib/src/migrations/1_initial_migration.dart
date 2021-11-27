import 'package:spending/src/domain/expense/expense.dart';
import 'package:spending/src/domain/expense_category/expense_category.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'migration.dart';

class InitialMigration extends Migration {
  @override
  Future<void> down(Database database) {
    throw UnimplementedError();
  }

  @override
  Future<void> up(Database database) async {
    await database.transaction((tx) async {
      await tx.execute('create table ${ExpenseCategory.tableName} ('
        '${ExpenseCategory.idFieldName} integer primary key autoincrement,'
        '${ExpenseCategory.nameFieldName} text not null'
        ')');

      await tx.execute('create table ${Expense.tableName} ('
        '${Expense.idFieldName} integer primary key autoincrement,'
        '${Expense.amountFieldName} text not null,'
        '${Expense.expenseCategoryIdFieldName} integer not null,'
        '${Expense.occurredOnFieldName} int not null,'
        '${Expense.createdAtFieldName} int not null,'
        'foreign key (${Expense.expenseCategoryIdFieldName}) references ${ExpenseCategory.tableName}(${ExpenseCategory.idFieldName})'
        ')');
    });
  }
}