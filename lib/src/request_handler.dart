import 'request.dart';

/// An abstract class representing a handler for a specific type of [Request].
/// This handler is responsible for processing the request and producing a result of type [TResult].
///
/// The generic type [TRequest] specifies the type of request that the handler can process,
/// and it must extend from [Request] with the same [TResult] type.
///
/// - [TRequest]: The type of the request that this handler can process.
/// - [TResult]: The type of the result that the handler returns upon processing the request.
abstract class RequestHandler<TRequest extends Request<TResult>, TResult> {
  /// The method to be implemented to handle the incoming [request].
  /// It processes the request and returns a result of type [TResult].
  ///
  /// - [request]: The request to be processed by this handler.
  TResult call(TRequest request);
}

/// An abstract class representing a handler for [Command] requests.
/// This handler processes commands and does not return any result, indicating
/// the completion of the command with a [Future] of [void].
///
/// The generic type [TRequest] specifies the type of command that the handler can process,
/// and it must extend from [Command].
///
/// - [TRequest]: The type of the command that this handler can process.
abstract class CommandHandler<TRequest extends Command>
    implements RequestHandler<TRequest, Future<void>> {}

/// An abstract class representing a handler for [Query] requests.
/// This handler processes queries and returns a result of type [TResult] wrapped in a [Future],
/// indicating the asynchronous nature of query processing.
///
/// The generic type [TRequest] specifies the type of query that the handler can process,
/// and it must extend from [Query] with the same [TResult] type.
///
/// - [TRequest]: The type of the query that this handler can process.
/// - [TResult]: The type of the result that the handler returns upon processing the query.
abstract class QueryHandler<TRequest extends Query<TResult>, TResult>
    implements RequestHandler<TRequest, Future<TResult>> {}
