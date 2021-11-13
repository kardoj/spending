import 'package:spending/src/domain/expense/commands/create_expense_command.dart';
import 'package:spending/src/infrastructure/commands/command.dart';
import 'package:spending/src/infrastructure/commands/command_result.dart';
import 'package:spending/src/infrastructure/database_provider.dart';
import 'package:spending/src/domain/expense/expense_repository.dart';
import 'package:sqflite/sqflite.dart';

class CommandMediator {
  final Database _database;

  static CommandMediator? _instance;

  CommandMediator._(this._database);

  static Future<CommandMediator> getInstance() async {
    final database = await DatabaseProvider.provide();
    return _instance ??= CommandMediator._(database);
  }

  // TODO: CommandResult<bool> on kasutu, sest bool (success või mitte) on juba CommandResult ise.
  // TODO: Mõte: Kuni ei ole mängus vajadust command'ist mingit tulemust tagastada võiks CommandResult olla mitte generic.
  // TODO: CommandResult võiks vea puhul sisaldada kollektsiooni teadetest.
  Future<CommandResult<bool>> send<TCommand extends Command<bool>>(TCommand command) async {
    if (command is CreateExpenseCommand) {
      final expenseRepository = ExpenseRepository(_database);
      return await CreateExpenseCommandHandler(expenseRepository).handle(command);
    }

    throw "Unknown command " + TCommand.toString();
  }
}