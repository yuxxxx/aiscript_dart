import 'package:aiscript_dart/interpreter/main.dart';
import 'package:aiscript_dart/interpreter/node.dart';
import 'package:aiscript_dart/parser/core/node.dart';
import 'package:test/test.dart';

class MockInterpreterOption extends InterpreterOption {
  @override
  Future<String> input(String q) => _input(q);
  final Future<String> Function(String q) _input;

  @override
  void output(Value value) => _output(value);
  final void Function(Value value) _output;

  @override
  void log(String type, Map<String, dynamic> params) => _log(type, params);
  final void Function(String type, Map<String, dynamic> params) _log;

  MockInterpreterOption(this._input, this._output, this._log);
}

void main() {
  final mockInterpreterOption = MockInterpreterOption(
      (q) => Future(() => q), (value) {}, (type, params) {});
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
}
