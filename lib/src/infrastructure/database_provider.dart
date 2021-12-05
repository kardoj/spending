import 'package:spending/src/configuration.dart';
import 'package:spending/src/domain/expense_category/expense_category.dart';
import 'package:spending/src/migrations/1_initial_migration.dart';
import 'package:spending/src/migrations/2_add_location_to_expense.dart';
import 'package:spending/src/migrations/3_add_a_few_expense_categories.dart';
import 'package:spending/src/migrations/4_add_delivery_expense_category.dart';
import 'package:spending/src/migrations/migration.dart';
import 'package:spending/src/migrations/migration_applier.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database? _database;
  static final Map<int, Migration> _versionToMigrationMap = {
    1: InitialMigration(),
    2: AddLocationToExpenseMigration(),
    3: AddAFewExpenseCategories(),
    4: AddDeliveryExpenseCategory(),
    // Add new migrations here and don't skip any version numbers.
  };

  DatabaseProvider._();

  static Future<Database> getInstance() async {
    _database ??= await openDatabase(Configuration.databaseFileName, version: 4,
      onConfigure: (Database database) async { await database.execute('PRAGMA foreign_keys = ON;'); },
      onUpgrade: (Database database, int oldVersion, int newVersion) async {
        MigrationApplier().goUp(_versionToMigrationMap, database, oldVersion, newVersion);

        // Seed data if needed after all the migrations have been run.
        _seedDataIfNeeded(database);
      },
      onDowngrade: (Database database, int oldVersion, int newVersion) async {
        MigrationApplier().goDown(_versionToMigrationMap, database, oldVersion, newVersion);
      });

    return _database!;
  }

  static Future<void> _seedDataIfNeeded(Database database) async {
    await _seedExpenseCategoriesIfNeeded(database);
  }

  static Future<void> _seedExpenseCategoriesIfNeeded(Database database) async {
    if ((await database.query(ExpenseCategory.tableName, columns: ['id'])).isEmpty) {
      await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Food' });
      await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Lunch' });
      await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Home' });
      await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Car' });
      await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Fuel' });
      await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Hobbies' });
      await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Entertainment' });
      await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Health' });
      await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Alcohol' });
      await database.insert(ExpenseCategory.tableName, { ExpenseCategory.nameFieldName: 'Bills' });
    }
  }
}