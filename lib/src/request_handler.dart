import 'request.dart';

/// TResult must be the same as generic of [Request]
///
abstract class RequestHandler<TRequest extends Request<TResult>, TResult> {
  TResult call(TRequest request);
}

/// Handler that returns future
abstract class CommandHandler<TRequest extends Command>
    implements RequestHandler<TRequest, Future<void>> {}

/// Handler that returns [TResult]
abstract class QueryHandler<TRequest extends Query<TResult>, TResult>
    implements RequestHandler<TRequest, Future<TResult>> {}
