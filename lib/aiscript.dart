import 'package:aiscript_dart/parser/core/binary_operator.dart';
import 'package:petitparser/petitparser.dart';

import 'parser/core/node.dart';

final sp = pattern(' \t').star();
final ws = whitespace().star();

Parser<dynamic> binaryOperator(expression) {
  return (char('(') & ws & expression & ws & char(')'))
      .map((value) => value[2]);
}

ValuedNode<dynamic> parse(text) {
  final parser = undefined();
  final numOperand = undefined();
  final boolOperand = undefined();
  final equatable = undefined();

  final num = number();
  final bool = boolean();
  final sl = str();
  final nul = string('null').map((_) => Literal(null, 'null'));
  final literal = (num | bool | sl | nul);

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

  // array
  final arrayItem = undefined();
  final array = (char('[') &
          (whitespace() | newline()).star() &
          arrayItem.trim().star() &
          (whitespace() | newline()).star() &
          char(']'))
      .map((value) {
    if (value[2] == null) return Array([]);
    final head =
        (value[2] as List<dynamic>).map((v) => v as ValuedNode<dynamic>);
    return Array(head);
  });

  // object
  final propertyValue = undefined();
  final property = (word().plus().flatten() &
          char(' ').star() &
          string(':') &
          char(' ').star() &
          propertyValue)
      .map((values) => [values[0], values[4]]);
  final propertyWithDelimiter =
      (property & whitespace().star() & char(';').or(newline()))
          .map((values) => values[0]);
  final obj = (char('{') &
          (whitespace() | newline()).star() &
          propertyWithDelimiter.trim().star() &
          property.optional() &
          (whitespace() | newline()).star() &
          char('}'))
      .map((values) {
    final items = values[3] == null ? values[2] : [...values[2], values[3]];
    return Literal({for (var kv in items) kv[0]: kv[1].value}, 'object');
  });

  final expr = undefined();
  final name = (letter() & word().star()).flatten().map((value) => value);
  final variable = (string('let') &
          pattern(' \t').star() &
          name &
          pattern(' \t').star() &
          expr)
      .map((values) => Definition(values[2], values[4]));
  final identifier = name.map((value) => Identifier(value[0]));
  arrayItem.set(array | obj | boolOperand | numOperand | literal);
  propertyValue.set(array | obj | boolOperand | numOperand | literal);
  parser.set(array | obj | boolOperand | numOperand | literal);
  expr.set(array | obj | boolOperand | numOperand | literal);

  return parser.parse(text).value as ValuedNode<dynamic>;
}

ChoiceParser<dynamic> boolean() {
  final trueLiteral = string("true").map((_) => Literal(true, 'boolean'));
  final falseLiteral = string("false").map((_) => Literal(false, 'boolean'));

  return (trueLiteral | falseLiteral);
}

ChoiceParser<dynamic> number() {
  final integer =
      (pattern('+-').optional() & ((pattern('1-9') & digit().star()) | digit()))
          .flatten()
          .map((value) => Literal(int.parse(value), 'number'));
  final real = (pattern('+-').optional() &
          ((pattern('1-9') & digit().star()) | digit()) &
          char('.') &
          digit().plus())
      .flatten()
      .map((value) => Literal(double.parse(value), 'number'));
  return (real | integer);
}

Parser<dynamic> str() {
  return (char('"') & word().plus().flatten() & char('"'))
      .map((values) => Literal(values[1] as String, 'string'));
}
