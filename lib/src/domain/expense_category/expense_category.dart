import 'package:spending/src/domain/entity.dart';

class ExpenseCategory extends Entity {
  final String name;

  ExpenseCategory(int id, this.name)
      : super(id);

  static const String tableName = 'expense_category';

  static const String idFieldName = 'id';
  static const String nameFieldName = 'name';

  static String createTableSql() {
    return 'create table expense_category ('
        'id integer primary key autoincrement,'
        'name text not null'
        ')';
  }
}