import 'package:aiscript_dart/exceptions/errors.dart';
import 'package:aiscript_dart/parser/core/node.dart';
import 'package:aiscript_dart/parser/plugins/validate_keyword.dart';
import 'package:test/test.dart';

void main() {
  group('check reserved word guard', () {
    for (final name in reservedWord) {
      test('the name of naming nodes should be guard $name as reserved word',
          () {
        expect(() => validateNode(Identifier(name)),
            throwsA(TypeMatcher<SyntaxError>()));
      });
      test(
          'the name of function arguments should be guard $name as reserved word',
          () {
        expect(
            () => validateNode(FunctionTypeDefinition(
                [NamedTypeDefinition(name, null)],
                NamedTypeDefinition('test', null))),
            throwsA(TypeMatcher<SyntaxError>()));
      });
    }
  });
}
