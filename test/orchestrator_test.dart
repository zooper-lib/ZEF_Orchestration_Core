import 'package:test/test.dart';
import 'package:zef_orchestration_core/zef_orchestration_core.dart';

void main() {
  group('Orchestrator Initialization Tests', () {
    test('Should throw StateError', () {
      expect(() => Orchestrator.I, throwsA(isA<StateError>()));
    });

    test('Should return an instance of Orchestrator', () {
      OrchestratorBuilder().withAdapter(ConcreteOrchestratorAdapter()).build();

      final instance = Orchestrator.I;
      expect(instance, isA<Orchestrator>());
    });
  });
}
