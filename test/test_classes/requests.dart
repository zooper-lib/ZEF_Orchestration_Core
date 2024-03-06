import 'package:zef_orchestration_core/zef_orchestration_core.dart';

class QueryOne extends Query<String> {
  final String testString;

  QueryOne(this.testString);
}

class QueryTwo extends Query<int> {
  final int testInt;

  QueryTwo(this.testInt);
}

class QueryThree extends Query<int> {}

class CommandOne extends Command {
  final String testString;

  CommandOne(this.testString);
}

class CommandTwo extends Command {
  final int testInt;

  CommandTwo(this.testInt);
}

class CommandThree extends Command {}
