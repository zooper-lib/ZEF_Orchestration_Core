import 'request.dart';
import 'request_handler.dart';

/// An abstract class defining the contract for an adapter that the [Orchestrator] uses
/// to interact with the underlying request handling mechanism. This adapter facilitates
/// the registration of command and query handlers, as well as the publishing and sending
/// of commands and queries, respectively.
///
/// Implementations of this adapter should define how these operations are carried out
/// in specific contexts, such as interfacing with different messaging systems or request
/// processing pipelines.
abstract class OrchestratorAdapter {
  /// Registers a handler for a specific type of [Command].
  /// This method should store the handler in a way that it can be retrieved when a command
  /// of the corresponding type needs to be processed.
  ///
  /// - [handler]: The command handler to be registered. This handler will be invoked when
  /// a command of type [TCommand] is published.
  Future<void> registerCommandHandler<TCommand extends Command>(
      CommandHandler<TCommand> handler);

  /// Registers a handler for a specific type of [Query].
  /// Similar to [registerCommandHandler], this method should store the query handler
  /// for future retrieval and execution when a query of the corresponding type is sent.
  ///
  /// - [handler]: The query handler to be registered. This handler will be invoked when
  /// a query of type [TQuery] with an expected result of type [TResult] is sent.
  Future<void> registerQueryHandler<TQuery extends Query<TResult>, TResult>(
      QueryHandler<TQuery, TResult> handler);

  /// Publishes a [Command] for processing. The method should identify the appropriate
  /// command handler registered for the type of the command and invoke it.
  ///
  /// - [request]: The command to be published and processed by its corresponding handler.
  Future<void> publish(Command request);

  /// Sends a [Query] for processing and awaits a result. The method should find the suitable
  /// query handler registered for the type of the query, invoke it, and return the result.
  ///
  /// - [request]: The query to be sent for processing. The result of the query processing,
  /// wrapped in a [Future], is returned by this method.
  Future<TResult> send<TResult>(Query<TResult> request);

  /// Unregisters all previously registered command and query handlers.
  /// This method should ensure that no handlers are left registered, effectively resetting
  /// the adapter's state concerning command and query processing.
  Future<void> unregisterAll();
}
