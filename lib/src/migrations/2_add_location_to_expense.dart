import 'package:spending/src/domain/expense/expense.dart';
import 'package:spending/src/migrations/migration.dart';
import 'package:sqflite_common/sqlite_api.dart';

class AddLocationToExpenseMigration extends Migration {
  @override
  Future<void> down(Database database) {
    throw UnimplementedError();
  }

  @override
  Future<void> up(Database database) async {
    await database.transaction((tx) async {
      await tx.rawUpdate('alter table ${Expense.tableName} '
        ' add column ${Expense.latitudeFieldName} real not null default 0');
      await tx.rawUpdate('alter table ${Expense.tableName} '
        ' add column ${Expense.longitudeFieldName} real not null default 0');
    });
  }
}