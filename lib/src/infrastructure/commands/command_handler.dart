import 'package:spending/src/infrastructure/commands/command.dart';
import 'package:spending/src/infrastructure/commands/command_result.dart';

abstract class CommandHandler<TCommand extends Command<bool>> {
  Future<CommandResult<bool>> handle(TCommand command);
}