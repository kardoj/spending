import 'package:spending/src/configuration.dart';
import 'package:spending/src/migrations/1_initial_migration.dart';
import 'package:spending/src/migrations/2_add_location_to_expense.dart';
import 'package:spending/src/migrations/3_add_a_few_expense_categories.dart';
import 'package:spending/src/migrations/4_add_delivery_expense_category.dart';
import 'package:spending/src/migrations/5_add_social_expense_category.dart';
import 'package:spending/src/migrations/6_add_clothes_expense_category.dart';
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
    5: AddSocialExpenseCategory(),
    6: AddClothesExpenseCategory(),
    // Add new migrations here and don't skip any version numbers.
  };

  DatabaseProvider._();

  static Future<Database> getInstance() async {
    _database ??= await openDatabase(Configuration.databaseFileName, version: 6,
      onConfigure: (Database database) async { await database.execute('PRAGMA foreign_keys = ON;'); },
      onUpgrade: (Database database, int oldVersion, int newVersion) async {
        await MigrationApplier().goUp(_versionToMigrationMap, database, oldVersion, newVersion);
      },
      onDowngrade: (Database database, int oldVersion, int newVersion) async {
        await MigrationApplier().goDown(_versionToMigrationMap, database, oldVersion, newVersion);
      });

    return _database!;
  }
}