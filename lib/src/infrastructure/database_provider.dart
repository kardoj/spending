import 'package:spending/src/configuration.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database? _database;

  DatabaseProvider._();

  static Future<Database> provide() async {
    _database ??= await openDatabase(Configuration.databaseFileName);

    return _database!;
  }
}