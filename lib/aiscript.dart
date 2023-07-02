import 'package:aiscript_dart/parser/core/binary_operator.dart';
import 'package:petitparser/petitparser.dart';

import 'parser/core/node.dart';

final sp = pattern(' \t').star();
final ws = pattern(' \t\r\n').star();
final wsp = pattern(' \t\r\n').plus();
ChoiceParser<dynamic> separator = ((ws & char(',') & ws) | wsp);

Parser<dynamic> binaryOperator(expression) {
  return (char('(') & ws & expression & ws & char(')'))
      .map((value) => value[2]);
}

Node parse(text) {
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
    if (value[2] == null) return Literal([], 'arr');
    final items = (value[2] as List<dynamic>).map((v) => v.value);
    return Literal(items, 'arr');
  });

  // object
  final propertyValue = undefined();
  final property =
      (word().plus().flatten() & ws & string(':') & ws & propertyValue)
          .map((values) => [values[0], values[4]]);
  final propertyWithDelimiter =
      (property & sp & pattern(',;').or(newline())).map((values) => values[0]);
  final obj = (char('{') &
          ws &
          propertyWithDelimiter.trim().star() &
          property.optional() &
          ws &
          char('}'))
      .map((values) {
    final items = values[3] == null ? values[2] : [...values[2], values[3]];
    return Literal({for (var kv in items) kv[0]: kv[1].value}, 'obj');
  });

  final expr = undefined();
  final type = undefined();

  final name = (letter() & word().star()).flatten().map((value) => value);
  final nameWithNameSpace =
      (name & char(':') & name).flatten().map((value) => value);

  final variable = ((string('let').map((_) => false) |
              string('var').map((_) => true)) &
          sp &
          name &
          (ws & char(':') & ws & type).map((value) => value[3]).optional() &
          ws &
          char('=') &
          ws &
          expr)
      .map((values) => Definition(values[2], values[7], values[3], values[0]));
  final identifier =
      (nameWithNameSpace | name).map((value) => Identifier(value));

  final genericNamedType = (name & sp & char('<') & sp & type & sp & char('>'))
      .map((value) => NamedTypeDefinition(value[0], value[4]));
  final primitiveNamedType =
      name.map((value) => NamedTypeDefinition(value, null));
  final argTypes = (type & (separator & type).star())
      .map((value) => [value[0], ...value[1].map((t) => t[1])]);
  final functionType = (string('@(') &
          ws &
          argTypes.optional() &
          ws &
          char(')') &
          ws &
          string('=>') &
          ws &
          type)
      .map((value) => FunctionTypeDefinition(value[2] ?? [], value[8]));
  type.set(genericNamedType | primitiveNamedType | functionType);
  arrayItem.set(array | obj | boolOperand | numOperand | literal);
  propertyValue.set(array | obj | boolOperand | numOperand | literal);
  expr.set(array | obj | boolOperand | numOperand | literal);

  parser.set(expr | variable | identifier);

  return parser.parse(text).value as Node;
}

Parser<dynamic> boolean() {
  final trueLiteral = string("true").map((_) => Literal(true, 'bool'));
  final falseLiteral = string("false").map((_) => Literal(false, 'bool'));

  return (trueLiteral | falseLiteral);
}

Parser<dynamic> number() {
  final integer =
      (pattern('+-').optional() & ((pattern('1-9') & digit().star()) | digit()))
          .flatten()
          .map((value) => Literal(int.parse(value), 'num'));
  final real = (pattern('+-').optional() &
          ((pattern('1-9') & digit().star()) | digit()) &
          char('.') &
          digit().plus())
      .flatten()
      .map((value) => Literal(double.parse(value), 'num'));
  return (real | integer);
}

Parser<dynamic> str() {
  Parser<String> characterNormal(String delimiter) => pattern('^$delimiter\\');
  Parser<String> characterEscape(String delimiter) => seq2(
        char('\\'),
        char(delimiter),
      ).map2((_, char) => char);
  Parser<String> characterPrimitive(String delimiter) => [
        characterNormal(delimiter),
        characterEscape(delimiter),
      ].toChoiceParser();
  final doubleQuote = (char('"') & characterPrimitive('"').star() & char('"'))
      .map((values) => Literal((values[1] as List<String>).join(), 'str'));
  final singleQuote = (char("'") & characterPrimitive("'").star() & char("'"))
      .map((values) => Literal((values[1] as List<String>).join(), 'str'));
  return (doubleQuote | singleQuote);
}
