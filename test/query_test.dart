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

  group('QueryHandler Registration |', () {
    test('Instance Registration | Single QueryHandler | Success', () {
      // Arrange
      final queryHandler = QueryOneHandlerOne();

      // Act & Assert
      expect(() => Orchestrator.I.registerQueryHandler(queryHandler),
          returnsNormally);
    });

    test('Factory Registration | Single QueryHandler | Success', () {
      // Arrange
      queryHandlerFactory() => QueryOneHandlerOne();

      // Act & Assert
      expect(
          () => Orchestrator.I.registerQueryHandlerFactory<QueryOne, String>(
              queryHandlerFactory),
          returnsNormally);
    });

    test('Duplicate Instance Registration | Same QueryHandler | Throws Error',
        () {
      // Arrange
      final queryHandler = QueryOneHandlerOne();
      Orchestrator.I.registerQueryHandler(queryHandler);

      // Act & Assert
      expect(() => Orchestrator.I.registerQueryHandler(queryHandler),
          throwsA(isA<StateError>()));
    });

    test('Distinct Instance Registration | Multiple QueryHandlers | Success',
        () {
      // Arrange
      final queryHandlerOne = QueryOneHandlerOne();
      final queryHandlerTwo = QueryTwoHandlerOne();

      // Act & Assert
      expect(() => Orchestrator.I.registerQueryHandler(queryHandlerOne),
          returnsNormally);
      expect(() => Orchestrator.I.registerQueryHandler(queryHandlerTwo),
          returnsNormally);
    });
  });

  group('QueryHandler Execution |', () {
    test('No Registered Handler | Send Query | Throws Error', () {
      // Arrange
      final query = QueryOne('test');

      // Act & Assert
      expect(() => Orchestrator.I.send(query), throwsA(isA<StateError>()));
    });

    test('Execute Registered Instance | Send Query | Returns Expected Value',
        () async {
      // Arrange
      final query = QueryOne('test');
      final queryHandler = QueryOneHandlerOne();
      Orchestrator.I.registerQueryHandler(queryHandler);

      // Act
      final result = await Orchestrator.I.send(query);

      // Assert
      expect(result, equals('test'));
    });

    test('Execute Registered Factory | Send Query | Returns Expected Value',
        () async {
      // Arrange
      final query = QueryOne('test');
      queryHandlerFactory() => QueryOneHandlerOne();
      Orchestrator.I
          .registerQueryHandlerFactory<QueryOne, String>(queryHandlerFactory);

      // Act
      final result = await Orchestrator.I.send(query);

      // Assert
      expect(result, equals('test'));
    });
  });
}
