import 'package:spending/src/domain/expenses/commands/create_expense_command.dart';
import 'package:spending/src/infrastructure/commands/command.dart';
import 'package:spending/src/infrastructure/commands/command_result.dart';
import 'package:spending/src/infrastructure/database_provider.dart';
import 'package:spending/src/infrastructure/expense_repository.dart';
import 'package:sqflite/sqflite.dart';

class CommandMediator {
  Database _database;

  static CommandMediator? _instance;

  CommandMediator._(this._database);

  static Future<CommandMediator> getInstance() async {
    final database = await DatabaseProvider.provide();
    return _instance ??= CommandMediator._(database);
  }

  Future<CommandResult<bool>> send<TCommand extends Command<bool>>(TCommand command) async {
    if (command is CreateExpenseCommand) {
      final expenseRepository = ExpenseRepository(_database);
      return await CreateExpenseCommandHandler(expenseRepository).handle(command);
    }

    throw "Unknown command " + TCommand.toString();
  }
}