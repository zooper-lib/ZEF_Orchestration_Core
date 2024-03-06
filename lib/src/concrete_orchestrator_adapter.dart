import 'package:zef_orchestration_core/src/request.dart';
import 'package:zef_orchestration_core/src/request_handler.dart';

import 'orchestrator_adapter.dart';

class ConcreteOrchestratorAdapter implements OrchestratorAdapter {
  final Map<Type, List<CommandHandler>> _commandHandlers = {};
  final Map<Type, QueryHandler> _queryHandlers = {};

  @override
  Future<void> registerCommandHandler<TCommand extends Command>(
      CommandHandler<TCommand> handler) async {
    // Register the handler
    _commandHandlers[TCommand] ??= [];

    // Check if the same handler is already registered
    if (_commandHandlers[TCommand]!.contains(handler)) {
      throw StateError(
          'A $CommandHandler for the command of type $TCommand has already been registered.');
    }

    _commandHandlers[TCommand]!.add(handler);
  }

  @override
  Future<void> registerQueryHandler<TQuery extends Query<TResult>, TResult>(
      QueryHandler<TQuery, TResult> handler) async {
    // Check if the handler is already registered
    if (_queryHandlers.containsKey(TQuery)) {
      throw StateError(
          'A $QueryHandler for the query of type $TQuery has already been registered.');
    }

    // Register the handler
    _queryHandlers[TQuery] = handler;
  }

  @override
  Future<void> publish(Command request) async {
    var handlers = _commandHandlers[request.runtimeType];

    if (handlers == null) {
      // TODO: Return a result
      throw StateError(
          'No $CommandHandler has been registered for the command of type ${request.runtimeType}.');
    }

    // Execute the handlers
    for (var handler in handlers) {
      await handler.call(request);
    }
  }

  @override
  Future<TResult> send<TResult>(Query<TResult> request) async {
    var handler = _queryHandlers[request.runtimeType];

    if (handler == null) {
      // TODO: Return a result
      throw StateError(
          'No $QueryHandler has been registered for the query of type ${request.runtimeType}.');
    }

    // Execute the handler
    return await handler.call(request);
  }

  @override
  Future<void> unregisterAll() async {
    _commandHandlers.clear();
    _queryHandlers.clear();
  }
}
