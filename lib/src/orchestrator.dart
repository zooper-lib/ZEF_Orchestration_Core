import 'package:zef_orchestration_core/src/default_orchestrator_adapter.dart';

import 'orchestrator_adapter.dart';
import 'request.dart';
import 'request_handler.dart';

/// A singleton orchestrator class responsible for handling and routing commands and queries
/// within the application. It acts as a central point for registering handlers and publishing
/// or sending requests.
///
/// The [Orchestrator] uses an [OrchestratorAdapter] to delegate the actual handling of requests,
/// making it flexible and adaptable to different execution contexts.
class Orchestrator {
  static Orchestrator? _instance;

  final OrchestratorAdapter _adapter;

  Orchestrator._(this._adapter);

  /// Gets the singleton instance of [Orchestrator].
  ///
  /// Throws [StateError] if the [Orchestrator] has not been initialized via [OrchestratorBuilder].
  static Orchestrator get instance {
    if (_instance == null) {
      throw StateError(
          'Orchestrator must be initialized using the OrchestratorBuilder before accessing the instance.');
    }

    return _instance!;
  }

  /// A shorthand accessor for the singleton instance of [Orchestrator].
  static Orchestrator get I => instance;

  /// Registers a [CommandHandler] within the [Orchestrator].
  ///
  /// This method delegates the registration to the underlying [OrchestratorAdapter].
  /// - [handler]: The [CommandHandler] to be registered.
  Future<void> registerCommandHandler<TCommand extends Command>(
          CommandHandler<TCommand> handler) =>
      _adapter.registerCommandHandler(handler);

  /// Registers a [QueryHandler] within the [Orchestrator].
  ///
  /// This method delegates the registration of a query handler to the underlying [OrchestratorAdapter].
  /// It supports only one handler per query type to ensure a single, unambiguous handler for each query type.
  ///
  /// - [handler]: The [QueryHandler] instance to be registered for processing queries of the corresponding type.
  Future<void> registerQueryHandler<TQuery extends Query<TResult>, TResult>(
          QueryHandler<TQuery, TResult> handler) =>
      _adapter.registerQueryHandler(handler);

  /// Registers a factory function to create a [CommandHandler] within the [Orchestrator].
  ///
  /// This method allows for deferred instantiation of the handler, beneficial for optimizing resource usage and
  /// handling complex initialization scenarios.
  ///
  /// - [handlerFactory]: The factory function that, when called, will create an instance of the [CommandHandler].
  Future<void> registerCommandHandlerFactory<TCommand extends Command>(
          CommandHandler<TCommand> Function() handlerFactory) =>
      _adapter.registerCommandHandlerFactory(handlerFactory);

  /// Registers a factory function to create a [QueryHandler] within the [Orchestrator].
  ///
  /// Similar to command handler factories, this allows deferred creation of query handlers, providing flexibility
  /// in handling initialization and dependencies.
  ///
  /// - [handlerFactory]: The factory function that, when called, will create an instance of the [QueryHandler].
  Future<void>
      registerQueryHandlerFactory<TQuery extends Query<TResult>, TResult>(
              QueryHandler<TQuery, TResult> Function() handlerFactory) =>
          _adapter.registerQueryHandlerFactory(handlerFactory);

  /// Publishes a [Command] through the [Orchestrator].
  ///
  /// This method locates the appropriate [CommandHandler] and invokes it to process the command.
  /// - [request]: The [Command] to be processed.
  Future<void> publish(Command request) => _adapter.publish(request);

  /// Sends a [Query] through the [Orchestrator] and awaits a result.
  ///
  /// This method finds the suitable [QueryHandler] and invokes it, returning the result of the query execution.
  /// - [request]: The [Query] to be processed.
  Future<TResult> send<TResult>(Query<TResult> request) =>
      _adapter.send(request);

  /// Unregisters all [RequestHandler] from the [Orchestrator].
  ///
  /// This method clears all registered command and query handlers, resetting the orchestrator's state.
  Future<void> unregisterAll() => _adapter.unregisterAll();
}

/// A builder class for configuring and initializing an [Orchestrator] instance.
///
/// This builder ensures that an [Orchestrator] is properly configured with an [OrchestratorAdapter]
/// before it is used.
class OrchestratorBuilder {
  OrchestratorAdapter _adapter = DefaultOrchestratorAdapter();

  /// Sets the [OrchestratorAdapter] for the [Orchestrator] being built.
  ///
  /// - [adapter]: The adapter to be used by the [Orchestrator].
  /// Returns the [OrchestratorBuilder] instance for chaining.
  OrchestratorBuilder withAdapter(OrchestratorAdapter adapter) {
    _adapter = adapter;
    return this;
  }

  /// Builds the [Orchestrator] singleton instance with the provided [OrchestratorAdapter].
  ///
  /// Throws [StateError] if the [Orchestrator] has already been initialized or if an adapter has not been provided.
  void build() {
    if (Orchestrator._instance != null) {
      throw StateError(
          '$Orchestrator has already been initialized and cannot be configured again.');
    }

    Orchestrator._instance = Orchestrator._(_adapter);
  }
}
