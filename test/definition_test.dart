import 'package:aiscript_dart/aiscript.dart';
import 'package:aiscript_dart/parser/core/node.dart';
import 'package:test/test.dart';

void main() {
  test('parse variant', () {
    expect(parse('variant'), Identifier('variant'));
  });

  test('parse inferred type definition', () {
    expect(parse('let variant = 2'),
        Definition('variant', Literal(2, 'num'), null, false));
  });

  test('parse typed definition', () {
    expect(
        parse('let variant : num = 2'),
        Definition('variant', Literal(2, 'num'),
            NamedTypeDefinition('num', null), false));
  });
}
