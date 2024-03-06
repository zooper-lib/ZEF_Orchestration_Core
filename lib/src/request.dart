/// The base class for any command or query
abstract class Request<TResult> {}

/// Request that returns a [Future] of [void]
abstract class Command extends Request<Future<void>> {}

/// Request that returns a [Future] of [TResult]
abstract class Query<TResult> extends Request<Future<TResult>> {}
