import 'package:aiscript_dart/main.dart';
import 'package:aiscript_dart/parser/core/node.dart';
import 'package:test/test.dart';

Node parseAndGetFirstNode(String text) => Parser.parseInput(text).first;

void main() {
  test('parse variant', () {
    expect(parseAndGetFirstNode('variant'), Identifier('variant'));
  });

  test('parse inferred type definition', () {
    expect(parseAndGetFirstNode('let variant = 2'),
        ValuableDefinition('variant', Literal(2, 'num'), null, false));
  });

  test('parse typed definition', () {
    expect(
        parseAndGetFirstNode('let variant : num = 2'),
        ValuableDefinition('variant', Literal(2, 'num'),
            NamedTypeDefinition('num', null), false));
  });

  test('parse variable definition', () {
    expect(
        parseAndGetFirstNode('''var obj
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
    expect(
        parseAndGetFirstNode('<: "hello world!"'),
        Identifier('print').chains([
          CallChain([Literal('hello world!', 'str')])
        ]));
  });

  test('parse return', () {
    expect(parseAndGetFirstNode('return 2'), Return(Literal(2, 'num')));
  });

  test('parse break', () {
    expect(parseAndGetFirstNode('break\n'), Break());
  });
  test('parse continue', () {
    expect(parseAndGetFirstNode('continue\n'), Continue());
  });

  test('parse foreach', () {
    expect(parseAndGetFirstNode(''' for i { break }'''),
        ForEach(Identifier('i'), Block([Break()])));
  });

  test('parse each', () {
    expect(parseAndGetFirstNode('each (let j k) return null'),
        Each('j', Identifier('k'), Return(Literal(null, 'null'))));
  });

  test('parse loop', () {
    expect(
        parseAndGetFirstNode('loop { let x = 2\n <: x } ').toString(),
        Loop([
          ValuableDefinition('x', Literal(2, 'num'), null, false),
          Identifier('print').chains([
            CallChain([Identifier('x')])
          ]) as Node
        ]).toString());
  });

  test('parse fndef', () {
    expect(
        parseAndGetFirstNode('@test(): bool { return true } '),
        FunctionDefinition(
            'test',
            FunctionNode([], NamedTypeDefinition('bool', null),
                [Return(Literal(true, 'bool'))]),
            false));
  });

  test('parse if', () {
    expect(parseAndGetFirstNode('if true 1 else 2'),
        If(Literal(true, 'bool'), Literal(1, 'num'), [], Literal(2, 'num')));
  });

  test('parse assign', () {
    expect(parseAndGetFirstNode('x = "test"'),
        Assign(Identifier('x'), Literal('test', 'str')));
  });

  test('parse assign 2', () {
    expect(parseAndGetFirstNode('x = y'),
        Assign(Identifier('x'), Identifier('y')));
  });
}
