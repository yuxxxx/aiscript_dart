import 'package:aiscript_dart/aiscript.dart';
import 'package:aiscript_dart/parser/core/node.dart';
import 'package:test/test.dart';

void main() {
  test('parse variant', () {
    expect(parse('variant'), Identifier('variant'));
  });

  test('parse inferred type definition', () {
    expect(parse('let variant = 2'),
        ValuableDefinition('variant', Literal(2, 'num'), null, false));
  });

  test('parse typed definition', () {
    expect(
        parse('let variant : num = 2'),
        ValuableDefinition('variant', Literal(2, 'num'),
            NamedTypeDefinition('num', null), false));
  });

  test('parse variable definition', () {
    expect(
        parse('''var obj
        = {
          hello: ['world']
        }'''),
        ValuableDefinition(
            'obj',
            Literal({
              'hello': ['world']
            }, 'obj'),
            null,
            true));
  });

  test('parse output', () {
    expect(parse('<: "hello world!"'),
        Identifier.chained('print', [Literal('hello world!', 'str')]));
  });
}
