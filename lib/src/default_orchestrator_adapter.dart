import 'package:zef_orchestration_core/src/request.dart';
import 'package:zef_orchestration_core/src/request_handler.dart';

import 'handler_storage.dart';
import 'orchestrator_adapter.dart';

class DefaultOrchestratorAdapter implements OrchestratorAdapter {
  final Map<Type, List<HandlerStorage<CommandHandler>>> _commandHandlers = {};
  final Map<Type, HandlerStorage<QueryHandler>> _queryHandlers = {};

  // Register command handler instance
  @override
  Future<void> registerCommandHandler<TCommand extends Command>(
      CommandHandler<TCommand> handler) async {
    final type = TCommand;

    _commandHandlers[type] ??= [];

    // Retrieve existing handlers for this command type, if any
    var handlers = _commandHandlers[type] ?? [];

    // Check if this handler instance is already registered
    for (var handlerStorage in handlers) {
      if (identical(handlerStorage.resolve(), handler)) {
        throw StateError(
            'This $CommandHandler instance is already registered for $type.');
      }
    }

    _commandHandlers[type]!.add(HandlerStorage.instance(handler));
  }

  // Register command handler factory
  @override
  Future<void> registerCommandHandlerFactory<TCommand extends Command,
          TCommandHandler extends CommandHandler<TCommand>>(
      TCommandHandler Function() handlerFactory) async {
    final type = TCommand;

    _commandHandlers[type] ??= [];

    // Retrieve existing handlers for this command type, if any
    var handlers = _commandHandlers[type] ?? [];

    // Check if a factory or handler for this type is already registered
    for (final handlerStorage in handlers) {
      if (handlerStorage.isFactory &&
          identical(handlerStorage.resolve(), handlerFactory)) {
        throw StateError(
            'This $CommandHandler is already registered for $type.');
      }
    }

    _commandHandlers[type]!.add(HandlerStorage.factory(handlerFactory));
  }

  // Register query handler instance
  @override
  Future<void> registerQueryHandler<TQuery extends Query<TResult>, TResult>(
      QueryHandler<TQuery, TResult> handler) async {
    final type = TQuery;

    if (_queryHandlers.containsKey(type)) {
      throw StateError('A $QueryHandler for $type is already registered.');
    }

    _queryHandlers[type] = HandlerStorage.instance(handler);
  }

  // Register query handler factory
  @override
  Future<void>
      registerQueryHandlerFactory<TQuery extends Query<TResult>, TResult>(
          Function() handlerFactory) async {
    final type = TQuery;

    if (_queryHandlers.containsKey(type)) {
      throw StateError('A $QueryHandler for $type is already registered.');
    }

    _queryHandlers[type] = HandlerStorage.factory(handlerFactory);
  }

  @override
  Future<void> publish(Command command) async {
    final type = command.runtimeType;
    final handlers = _commandHandlers[type];
    if (handlers == null || handlers.isEmpty) {
      throw StateError('No $CommandHandler registered for $type.');
    }

    for (var storage in handlers) {
      final handler = storage.resolve();
      await handler(command);
    }
  }

  @override
  Future<TResult> send<TResult>(Query<TResult> query) async {
    final type = query.runtimeType;
    final storage = _queryHandlers[type];
    if (storage == null) {
      throw StateError('No $QueryHandler registered for $type.');
    }

    final handler = storage.resolve() as QueryHandler<Query<TResult>, TResult>;
    return await handler(query);
  }

  @override
  Future<void> unregisterAll() async {
    _commandHandlers.clear();
    _queryHandlers.clear();
  }
}
