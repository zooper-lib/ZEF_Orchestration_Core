import 'package:zef_orchestration_core/zef_orchestration_core.dart';

class SampleCommand extends Command {}

class SampleCommandHandler extends CommandHandler<SampleCommand> {
  @override
  Future<void> call(SampleCommand command) async {
    print('Executing SampleCommand...');
    // Command execution logic here
  }
}

// Define a sample query and its handler.
class SampleQuery extends Query<String> {}

class SampleQueryHandler extends QueryHandler<SampleQuery, String> {
  @override
  Future<String> call(SampleQuery query) async {
    print('Executing SampleQuery...');
    return 'Query Result';
  }
}

void main() async {
  // Initialize the orchestrator with the simple adapter.
  OrchestratorBuilder().build();

  // Register command and query handlers.
  await Orchestrator.I.registerCommandHandler(SampleCommandHandler());
  await Orchestrator.I.registerQueryHandler(SampleQueryHandler());

  // Publish a command.
  await Orchestrator.I.publish(SampleCommand());

  // Send a query and await the result.
  final result = await Orchestrator.I.send(SampleQuery());
  print('Query returned: $result');

  // Optionally, unregister all handlers.
  await Orchestrator.I.unregisterAll();
}
