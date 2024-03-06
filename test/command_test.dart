import 'package:test/test.dart';
import 'package:zef_orchestration_core/zef_orchestration_core.dart';

import 'test_classes/request_handlers.dart';
import 'test_classes/requests.dart';

void main() {
  setUpAll(
    () => OrchestratorBuilder()
        .withAdapter(ConcreteOrchestratorAdapter())
        .build(),
  );

  tearDown(
    () => Orchestrator.I.unregisterAll(),
  );

  group('Registration tests', () {
    test('Register CommandHandler - Expect success', () {
      // Arrange
      final commandHandler = CommandOneHandlerOne();

      // Act & Assert
      expect(() => Orchestrator.I.registerCommandHandler(commandHandler),
          returnsNormally);
    });

    test('Register CommandHandler twice - Expect already registered error', () {
      // Arrange
      final commandHandler = CommandOneHandlerOne();
      Orchestrator.I.registerCommandHandler(commandHandler);

      // Act & Assert
      expect(
        () => Orchestrator.I.registerCommandHandler(commandHandler),
        throwsA(isA<StateError>()),
      );
    });

    test('Register multiple CommandHandlers - Expect success', () {
      // Arrange
      final command = CommandOne('test');
      final commandHandlerOne = CommandOneHandlerOne();
      final commandHandlerTwo = CommandOneHandlerTwo();
      Orchestrator.I.registerCommandHandler(commandHandlerOne);
      Orchestrator.I.registerCommandHandler(commandHandlerTwo);

      // Act & Assert
      expect(() => Orchestrator.I.publish(command), returnsNormally);
    });
  });

  group('Execution tests', () {
    test('Publish CommandHandler - Expect CommandHandler not registered', () {
      // Arrange
      final command = CommandOne('test');

      // Act & Assert
      expect(() => Orchestrator.I.publish(command), throwsA(isA<StateError>()));
    });

    test('CommandHandler gets executed correctly - Expected console output',
        () {
      // Arrange
      final command = CommandOne('test');
      final commandHandler = CommandOneHandlerOne();
      Orchestrator.I.registerCommandHandler(commandHandler);

      // Act
      Orchestrator.I.publish(command);

      // Assert
      expect(
        () => Orchestrator.I.publish(command),
        prints('CommandOneHandlerOne called with test\n'),
      );
    });

    test(
        'Multiple CommandHandler get executed correctly - Expected console outputs',
        () {
      // Arrange
      final command = CommandOne('test');
      final commandHandlerOne = CommandOneHandlerOne();
      final commandHandlerTwo = CommandOneHandlerTwo();
      Orchestrator.I.registerCommandHandler(commandHandlerOne);
      Orchestrator.I.registerCommandHandler(commandHandlerTwo);

      // Act
      Orchestrator.I.publish(command);

      // Assert
      expect(
        () => Orchestrator.I.publish(command),
        prints('CommandOneHandlerOne called with test\n'
            'CommandOneHandlerTwo called with test\n'),
      );
    });
  });
}
