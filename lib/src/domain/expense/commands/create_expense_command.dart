import 'package:decimal/decimal.dart';
import 'package:spending/src/infrastructure/commands/command.dart';
import 'package:spending/src/infrastructure/commands/command_handler.dart';
import 'package:spending/src/infrastructure/commands/command_result.dart';
import 'package:spending/src/domain/expense/expense_repository.dart';

class CreateExpenseCommand extends Command<bool> {
  final Decimal amount;
  final int expenseCategoryId;
  final DateTime occurredOn;

  CreateExpenseCommand(this.amount, this.expenseCategoryId, this.occurredOn);
}

class CreateExpenseCommandHandler implements CommandHandler<CreateExpenseCommand> {
  final ExpenseRepository _repository;

  CreateExpenseCommandHandler(this._repository);

  @override
  Future<CommandResult<bool>> handle(CreateExpenseCommand command) async {
    await _repository.create(command.amount, command.expenseCategoryId, command.occurredOn);
    return CommandResult.success(true);
  }
}