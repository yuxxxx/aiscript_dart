import 'dart:ffi';

import 'package:aiscript_dart/parser/core/binary_operator.dart';
import 'package:petitparser/petitparser.dart';

int calculate() {
  return 6 * 7;
}

Parser<dynamic> binaryOperator(expression) {
  return (char('(').trim() & expression & char(')')).map((value) => value[1]);
}

Node<dynamic> parse(text) {
  final parser = undefined();
  final numOperand = undefined();
  final boolOperand = undefined();
  final equatable = undefined();

  final num = number();
  final bool = boolean();
  final sl = str();
  final literal = (num | bool | sl);

  final eq = (equatable & string('==').trim() & equatable)
      .map((values) => Equal(values[0], values[2]));
  final ne = (equatable & string('!=').trim() & equatable)
      .map((values) => NotEqual(values[0], values[2]));

  final lt = (numOperand & char('>').trim() & numOperand)
      .map((values) => LessThan(values[0], values[2]));
  final gt = (numOperand & char('<').trim() & numOperand)
      .map((values) => GreaterThan(values[0], values[2]));

  final and = (boolOperand & string('&&').trim() & boolOperand)
      .map((values) => And(values[0], values[2]));
  final or = (boolOperand & string('||').trim() & boolOperand)
      .map((values) => Or(values[0], values[2]));
  final compaarers = (eq | ne | lt | gt);

  final binaryBool = binaryOperator(compaarers | and | or);
  equatable.set(boolOperand | num | bool | sl);
  boolOperand.set(binaryBool | bool);

  final minus = (numOperand & char('-').trim() & numOperand)
      .map((values) => Minus(values[0], values[2]));
  final plus = (numOperand & char('+').trim() & numOperand)
      .map((values) => Plus(values[0], values[2]));
  final multiply = (numOperand & char('*').trim() & numOperand)
      .map((values) => Multiply(values[0], values[2]));
  final divide = (numOperand & char('/').trim() & numOperand)
      .map((values) => Divide(values[0], values[2]));
  final modulo = (numOperand & char('%').trim() & numOperand)
      .map((values) => Modulo(values[0], values[2]));
  final power = (numOperand & char('^').trim() & numOperand)
      .map((values) => Power(values[0], values[2]));

  final binaryCalc =
      binaryOperator(minus | plus | multiply | divide | modulo | power);
  numOperand.set(binaryCalc | num);

  parser.set(binaryBool | numOperand | literal);
  return parser.end().parse(text).value as Node<dynamic>;
}

ChoiceParser<dynamic> boolean() {
  final trueLiteral = string("true").map((_) => Literal(true));
  final falseLiteral = string("false").map((_) => Literal(false));

  return (trueLiteral | falseLiteral);
}

ChoiceParser<dynamic> number() {
  final integer =
      digit().plus().flatten().trim().map((value) => Literal(int.parse(value)));
  final real = (digit().plus() & char('.') & digit().plus())
      .flatten()
      .trim()
      .map((value) => Literal(double.parse(value)));
  return (real | integer);
}

Parser<dynamic> str() {
  return (char('"') & word().plus().flatten() & char('"'))
      .map((values) => Literal(values[1] as String));
}
