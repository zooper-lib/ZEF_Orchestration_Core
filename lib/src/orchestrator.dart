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
          '$Orchestrator must be initialized using the $OrchestratorBuilder before accessing the instance.');
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
  /// This method delegates the registration of a query handler to the underlying [OrchestratorAdapter]. It is crucial to note that the orchestrator supports only one handler per query type. If a handler for a specific query type is already registered, attempting to register another handler for the same query type will replace the existing one.
  ///
  /// This design ensures that each query type has a single, unambiguous handler responsible for processing it, thereby avoiding conflicts or inconsistencies that could arise from having multiple handlers for the same query type.
  ///
  /// - [handler]: The [QueryHandler] instance to be registered. This handler will be invoked to process queries of the corresponding type.
  ///
  /// Example usage:
  /// ```dart
  /// Orchestrator.I.registerQueryHandler<YourSpecificQueryType, YourQueryResultType>(YourQueryHandler());
  /// ```
  Future<void> registerQueryHandler<TQuery extends Query<TResult>, TResult>(
          QueryHandler<TQuery, TResult> handler) =>
      _adapter.registerQueryHandler(handler);

  /// Publishes a [Command] through the [Orchestrator].
  ///
  /// This method delegates the [Command] publishing to the underlying [OrchestratorAdapter].
  /// - [request]: The [Command] to be published.
  Future<void> publish(Command request) => _adapter.publish(request);

  /// Sends a [Query] through the [Orchestrator] and awaits a result.
  ///
  /// This method delegates the [Query] sending to the underlying [OrchestratorAdapter].
  /// - [request]: The [Query] to be sent.
  /// Returns the result of the query execution.
  Future<TResult> send<TResult>(Query<TResult> request) =>
      _adapter.send(request);

  /// Unregisters all [RequestHandler] from the [Orchestrator].
  ///
  /// This method delegates the unregistration to the underlying [OrchestratorAdapter].
  Future<void> unregisterAll() => _adapter.unregisterAll();
}

/// A builder class for configuring and initializing an [Orchestrator] instance.
///
/// This builder ensures that an [Orchestrator] is properly configured with an [OrchestratorAdapter]
/// before it is used.
class OrchestratorBuilder {
  OrchestratorAdapter? _adapter;

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

    if (_adapter == null) {
      throw StateError(
          'A $OrchestratorAdapter must be provided before building the $Orchestrator.');
    }

    Orchestrator._instance = Orchestrator._(_adapter!);
  }
}
