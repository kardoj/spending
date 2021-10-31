import 'package:spending/src/configuration.dart';
import 'package:spending/src/domain/expense/expense.dart';
import 'package:spending/src/domain/expense_category/expense_category.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database? _database;

  DatabaseProvider._();

  static Future<Database> provide() async {
    _database ??= await openDatabase(Configuration.databaseFileName, version: 1,
      onOpen: (Database database) async { await database.execute('PRAGMA foreign_keys = ON;'); },
      onCreate: (Database database, int version) async {
        await _createDatabase(database, version);
        await _seedInitialData(database, version);
      });

    return _database!;
  }

  static Future<void> _createDatabase(Database database, int version) async {
    await database.execute(ExpenseCategory.createTableSql());
    await database.execute(Expense.createTableSql());
  }

  static Future<void> _seedInitialData(Database database, int version) async {
    await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Food' });
    await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Lunch' });
    await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Home' });
    await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Car' });
    await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Fuel' });
    await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Hobbies' });
  }
}