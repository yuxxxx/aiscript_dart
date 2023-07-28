import 'package:aiscript_dart/parser/core/accessor.dart';
import 'package:aiscript_dart/parser/core/node.dart';
import 'package:aiscript_dart/parser/plugins/transform_chain.dart';
import 'package:test/test.dart';

void main() {
  test('transform IndexChain', () {
    expect(
        transformNode(
            Identifier('arr').chains([IndexChain(Literal(2, 'num'))]) as Node),
        Index(Identifier('arr'), Literal(2, 'num')));
  });
  test('transform PropertyChain', () {
    expect(
        transformNode(
            Identifier('arr').chains([PropertyChain('length')]) as Node),
        Property(Identifier('arr'), 'length'));
  });

  test('transform CallChain', () {
    expect(
        transformNode(Identifier('fn').chains([
          CallChain([Literal('a', 'str'), Identifier('x')])
        ]) as Node),
        Call(Identifier('fn'), [Literal('a', 'str'), Identifier('x')]));
  });

  test('transform chained chains', () {
    expect(
        transformNode(Identifier('arr').chains([
          IndexChain(Literal(2, 'num')),
          CallChain([Identifier('x')]),
          PropertyChain('length')
        ]) as Node),
        Property(
            Call(
                Index(Identifier('arr'), Literal(2, 'num')), [Identifier('x')]),
            'length'));
  });
}
