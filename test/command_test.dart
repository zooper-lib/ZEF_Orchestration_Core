import 'package:test/test.dart';
import 'package:zef_orchestration_core/zef_orchestration_core.dart';

import 'test_classes/request_handlers.dart';
import 'test_classes/requests.dart';

void main() {
  setUpAll(() {
    // Arrange
    OrchestratorBuilder().build();
  });

  tearDown(() {
    // Cleanup
    Orchestrator.I.unregisterAll();
  });

  group('Handler Registration |', () {
    test('Direct Registration | CommandHandler | Success', () {
      // Arrange
      final commandHandler = CommandOneHandlerOne();

      // Act & Assert
      expect(() => Orchestrator.I.registerCommandHandler(commandHandler),
          returnsNormally);
    });

    test('Factory Registration | CommandHandler | Success', () {
      // Arrange
      CommandHandler<CommandOne> commandHandlerFactory() =>
          CommandOneHandlerOne();

      // Act & Assert
      expect(
          () => Orchestrator.I
              .registerCommandHandlerFactory<CommandOne>(commandHandlerFactory),
          returnsNormally);
    });

    test('Duplicate Registration | CommandHandler | Throws Error', () {
      // Arrange
      final commandHandler = CommandOneHandlerOne();
      Orchestrator.I.registerCommandHandler(commandHandler);

      // Act & Assert
      expect(() => Orchestrator.I.registerCommandHandler(commandHandler),
          throwsA(isA<StateError>()));
    });

    test('Multiple Handlers | Same Command Type | Success', () {
      // Arrange
      final command = CommandOne('test');
      final commandHandlerOne = CommandOneHandlerOne();
      final commandHandlerTwo = CommandOneHandlerTwo();

      // Act
      Orchestrator.I.registerCommandHandler(commandHandlerOne);
      Orchestrator.I.registerCommandHandler(commandHandlerTwo);

      // Assert
      expect(() => Orchestrator.I.publish(command), returnsNormally);
    });
  });

  group('Handler Execution |', () {
    test('No Handler | Publish Command | Throws Error', () {
      // Arrange
      final command = CommandOne('test');

      // Act & Assert
      expect(() => Orchestrator.I.publish(command), throwsA(isA<StateError>()));
    });

    test('Direct Handler Execution | Command | Expected Output', () async {
      // Arrange
      final command = CommandOne('test');
      final commandHandler = CommandOneHandlerOne();
      Orchestrator.I.registerCommandHandler(commandHandler);

      // Act & Assert
      await Orchestrator.I.publish(command);
      expect(() async => await Orchestrator.I.publish(command),
          prints('CommandOneHandlerOne called with test\n'));
    });

    test('Multiple Handlers Execution | Command | Expected Outputs', () async {
      // Arrange
      final command = CommandOne('test');
      final commandHandlerOne = CommandOneHandlerOne();
      final commandHandlerTwo = CommandOneHandlerTwo();
      Orchestrator.I.registerCommandHandler(commandHandlerOne);
      Orchestrator.I.registerCommandHandler(commandHandlerTwo);

      // Act & Assert
      await Orchestrator.I.publish(command);
      expect(() async => await Orchestrator.I.publish(command),
          prints(contains('CommandOneHandlerOne called with test')));
    });
  });
}
