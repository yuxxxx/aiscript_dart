import 'package:aiscript_dart/interpreter/main.dart';
import 'package:aiscript_dart/interpreter/node.dart';
@GenerateNiceMocks([MockSpec<InterpreterOption>()])
import 'package:aiscript_dart/main.dart' show Parser;
import 'package:aiscript_dart/parser/core/node.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockInterpreterOption extends Mock implements InterpreterOption {}

void main() {
  final mockInterpreterOption = MockInterpreterOption();
  test('construct Interpreter', () {
    final interpreter = Interpreter.initWithDefault();
    expect(interpreter.scope, isNotNull);
    expect(interpreter.option, isNotNull);
    expect(interpreter.stop, false);
  });

  test('execute simple string', () async {
    final interpreter = Interpreter({}, mockInterpreterOption);
    final result = await interpreter
        .runInternal([Literal('hello world!', 'str')], interpreter.scope!);
    expect(result.value, 'hello world!');
  });

  test('parse simple string', () async {
    final interpreter = Interpreter({}, mockInterpreterOption);
    final nodes = Parser().parse('"hello world!"');
    print(nodes);
    await interpreter.execute(nodes);
    verify(mockInterpreterOption.log('end', {'val': Str('hello world!')}))
        .called(1);
  });
}
