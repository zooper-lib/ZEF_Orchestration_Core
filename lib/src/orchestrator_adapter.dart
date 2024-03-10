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
  /// Registers a handler instance for a specific type of [Command].
  /// This method should store the handler instance in a way that it can be retrieved
  /// and invoked when a command of the corresponding type needs to be processed.
  ///
  /// - [handler]: The command handler instance to be registered. This handler will be invoked
  /// directly when a command of type [TCommand] is published.
  Future<void> registerCommandHandler<TCommand extends Command>(
      CommandHandler<TCommand> handler);

  /// Registers a factory function for creating a command handler for a specific type of [Command].
  /// This method allows for deferred creation of the handler, with the factory function being
  /// called to instantiate the handler when needed. This can be useful for lazy initialization
  /// or when handler instantiation requires additional setup or dependencies.
  ///
  /// - [handlerFactory]: The factory function to create a command handler instance. This function
  /// should return an instance of a [CommandHandler] for the specified [TCommand].
  Future<void> registerCommandHandlerFactory<TCommand extends Command,
          TCommandHandler extends CommandHandler<TCommand>>(
      TCommandHandler Function() handlerFactory);

  /// Registers a handler instance for a specific type of [Query].
  /// Similar to [registerCommandHandler], this method stores the query handler instance
  /// for future retrieval and execution when a query of the corresponding type is sent.
  ///
  /// - [handler]: The query handler instance to be registered. This handler will be invoked
  /// directly when a query of type [TQuery] with an expected result of type [TResult] is sent.
  Future<void> registerQueryHandler<TQuery extends Query<TResult>, TResult>(
      QueryHandler<TQuery, TResult> handler);

  /// Registers a factory function for creating a query handler for a specific type of [Query].
  /// This method is analogous to [registerCommandHandlerFactory] but for queries, allowing for
  /// deferred creation of query handlers. This is particularly useful for queries that may require
  /// significant resources or setup and should only be instantiated when needed.
  ///
  /// - [handlerFactory]: The factory function to create a query handler instance. This function
  /// should return an instance of a [QueryHandler] for the specified [TQuery] and [TResult].
  Future<void>
      registerQueryHandlerFactory<TQuery extends Query<TResult>, TResult>(
          QueryHandler<TQuery, TResult> Function() handlerFactory);

  /// Publishes a [Command] for processing. This method should identify the appropriate
  /// command handler (or instantiate one using the registered factory function) for the type
  /// of the command and invoke it.
  ///
  /// - [request]: The command to be published and processed by its corresponding handler.
  Future<void> publish(Command request);

  /// Sends a [Query] for processing and awaits a result. This method should find the suitable
  /// query handler (or create one from the registered factory function) for the type of the query,
  /// invoke it, and return the result.
  ///
  /// - [request]: The query to be sent for processing. The result of the query processing,
  /// wrapped in a [Future], is returned by this method.
  Future<TResult> send<TResult>(Query<TResult> request);

  /// Unregisters all previously registered command and query handlers and their factories.
  /// This method should ensure that no handlers or factories are left registered, effectively
  /// resetting the adapter's state with respect to command and query processing.
  Future<void> unregisterAll();
}
