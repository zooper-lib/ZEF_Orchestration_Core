import 'orchestrator_adapter.dart';
import 'request.dart';
import 'request_handler.dart';

class Orchestrator {
  static Orchestrator? _instance;

  Orchestrator._(this._adapter);

  static Orchestrator get instance {
    if (_instance == null) {
      throw StateError(
          '$Orchestrator must be initialized using the $OrchestratorBuilder before accessing the instance.');
    }

    return _instance!;
  }

  static Orchestrator get I => instance;

  final OrchestratorAdapter _adapter;

  Future<void> registerCommandHandler<TCommand extends Command>(
          CommandHandler<TCommand> handler) =>
      _adapter.registerCommandHandler(handler);

  Future<void> registerQueryHandler<TQuery extends Query<TResult>, TResult>(
          QueryHandler<TQuery, TResult> handler) =>
      _adapter.registerQueryHandler(handler);

  Future<void> publish(Command request) => _adapter.publish(request);

  Future<TResult> send<TResult>(Query<TResult> request) =>
      _adapter.send(request);

  Future<void> unregisterAll() => _adapter.unregisterAll();
}

class OrchestratorBuilder {
  OrchestratorAdapter? _adapter;

  OrchestratorBuilder withAdapter(OrchestratorAdapter adapter) {
    _adapter = adapter;
    return this;
  }

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
