/// An abstract base class representing a request within the application.
/// This class is designed to be a generic placeholder for any type of request,
/// whether it's a command (performing an action) or a query (retrieving data).
///
/// The generic type [TResult] represents the expected result type of the request
/// once it is processed.
///
/// - [TResult]: The type of the result that the request is expected to produce.
abstract class Request<TResult> {}

/// An abstract class representing a command in the application.
/// Commands are specialized types of requests that perform actions, usually
/// modifying the state of the application, and do not return a value.
///
/// Inherits from [Request] with a [Future] of [void] as its result type,
/// indicating that the command's execution might be asynchronous but does not
/// produce a return value.
abstract class Command extends Request<Future<void>> {}

/// An abstract class representing a query in the application.
/// Queries are specialized types of requests that retrieve data from the application,
/// without modifying its state.
///
/// Inherits from [Request] with a [Future] of [TResult] as its result type,
/// indicating that the query's execution is asynchronous and produces a return value
/// of type [TResult].
///
/// - [TResult]: The type of the result that the query is expected to produce.
abstract class Query<TResult> extends Request<Future<TResult>> {}
