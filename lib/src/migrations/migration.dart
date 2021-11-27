import 'package:sqflite/sqflite.dart';

abstract class Migration {
  Future<void> up(Database database);
  Future<void> down(Database database);
}