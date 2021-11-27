import 'package:spending/src/migrations/migration.dart';
import 'package:sqflite/sqflite.dart';

class MigrationApplier {
  Future<void> goUp(Map<int, Migration> versionToMigrationMap, Database database, int oldVersion, int newVersion) async {
    for (var i = oldVersion + 1; i <= newVersion; i++) {
      await versionToMigrationMap[i]!.up(database);
    }
  }

  Future<void> goDown(Map<int, Migration> versionToMigrationMap, Database database, int oldVersion, int newVersion) async {
    for (var i = oldVersion; i > newVersion; i--) {
      await versionToMigrationMap[i]!.down(database);
    }
  }
}