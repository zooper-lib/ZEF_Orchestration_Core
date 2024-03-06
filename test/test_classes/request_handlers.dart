import 'package:zef_orchestration_core/zef_orchestration_core.dart';

import 'requests.dart';

class QueryOneHandlerOne extends QueryHandler<QueryOne, String> {
  @override
  Future<String> call(QueryOne request) async {
    return request.testString;
  }
}

class QueryOneHandlerTwo extends QueryHandler<QueryOne, String> {
  @override
  Future<String> call(QueryOne request) async {
    return request.testString;
  }
}

class QueryTwoHandlerOne extends QueryHandler<QueryTwo, int> {
  @override
  Future<int> call(QueryTwo request) async {
    return request.testInt;
  }
}

class QueryThreeHandlerOne extends QueryHandler<QueryThree, int> {
  @override
  Future<int> call(QueryThree request) async {
    return 3;
  }
}

class CommandOneHandlerOne extends CommandHandler<CommandOne> {
  @override
  Future<void> call(CommandOne request) async {
    print('CommandOneHandlerOne called with ${request.testString}');
  }
}

class CommandOneHandlerTwo extends CommandHandler<CommandOne> {
  @override
  Future<void> call(CommandOne request) async {
    print('CommandOneHandlerTwo called with ${request.testString}');
  }
}

class CommandTwoHandlerOne extends CommandHandler<CommandTwo> {
  @override
  Future<void> call(CommandTwo request) async {
    print(request.testInt);
  }
}

class CommandThreeHandlerOne extends CommandHandler<CommandThree> {
  @override
  Future<void> call(CommandThree request) async {
    print('CommandThree');
  }
}
