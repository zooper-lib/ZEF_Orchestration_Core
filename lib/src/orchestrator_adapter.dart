import 'request.dart';
import 'request_handler.dart';

abstract class OrchestratorAdapter {
  Future<void> registerCommandHandler<TCommand extends Command>(
      CommandHandler<TCommand> handler);

  Future<void> registerQueryHandler<TQuery extends Query<TResult>, TResult>(
      QueryHandler<TQuery, TResult> handler);

  Future<void> publish(Command request);

  Future<TResult> send<TResult>(Query<TResult> request);

  Future<void> unregisterAll();
}
