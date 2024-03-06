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
    test('Register QueryHandler - Expect success', () {
      // Arrange
      final queryHandler = QueryOneHandlerOne();

      // Act & Assert
      expect(() => Orchestrator.I.registerQueryHandler(queryHandler),
          returnsNormally);
    });

    test('Register QueryHandler twice - Expect already registered error', () {
      // Arrange
      final queryHandler = QueryOneHandlerOne();
      Orchestrator.I.registerQueryHandler(queryHandler);

      // Act & Assert
      expect(
        () => Orchestrator.I.registerQueryHandler(queryHandler),
        throwsA(isA<StateError>()),
      );
    });

    test('Register Query twice - Expect already registered error', () {
      // Arrange
      final queryHandlerOne = QueryOneHandlerOne();
      final queryHandlerTwo = QueryOneHandlerTwo();
      Orchestrator.I.registerQueryHandler(queryHandlerOne);

      // Act & Assert
      expect(
        () => Orchestrator.I.registerQueryHandler(queryHandlerTwo),
        throwsA(isA<StateError>()),
      );
    });

    test('Register multiple Queries and QueryHandler - Expect success', () {
      // Arrange
      final queryHandlerOne = QueryOneHandlerOne();
      final queryHandlerTwo = QueryTwoHandlerOne();
      final queryHandlerThree = QueryThreeHandlerOne();

      // Act & Assert
      expect(
          () => Orchestrator.I
              .registerQueryHandler<QueryOne, String>(queryHandlerOne),
          returnsNormally);
      expect(
          () => Orchestrator.I
              .registerQueryHandler<QueryTwo, int>(queryHandlerTwo),
          returnsNormally);
      expect(
          () => Orchestrator.I
              .registerQueryHandler<QueryThree, int>(queryHandlerThree),
          returnsNormally);
    });
  });
}
