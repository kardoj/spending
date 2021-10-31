import 'package:decimal/decimal.dart';
import 'package:spending/src/infrastructure/commands/command.dart';
import 'package:spending/src/infrastructure/commands/command_handler.dart';
import 'package:spending/src/infrastructure/commands/command_result.dart';
import 'package:spending/src/infrastructure/expense_repository.dart';

class CreateExpenseCommand implements Command<bool> {
  Decimal _amount;
  int _expenseCategoryId;
  DateTime _dateTime;

  CreateExpenseCommand(this._amount, this._expenseCategoryId, this._dateTime);
}

class CreateExpenseCommandHandler implements CommandHandler<CreateExpenseCommand> {
  ExpenseRepository _repository;

  CreateExpenseCommandHandler(this._repository);

  @override
  Future<CommandResult<bool>> handle(CreateExpenseCommand command) async {
    return CommandResult.success(true);
  }
}