import 'package:aiscript_dart/parser/core/binary_operator.dart';
import 'package:petitparser/petitparser.dart';

import 'parser/core/node.dart';

final sp = pattern(' \t').star();
final ws = pattern(' \t\r\n').star();
final wsp = pattern(' \t\r\n').plus();
ChoiceParser<dynamic> separator = ((ws & char(',') & ws) | wsp);

Parser<dynamic> curlyBracket(expression) {
  return (char('(') & ws & expression & ws & char(')'))
      .map((value) => value[2]);
}

Iterable<Node> parseMain(text) {
  final name = (letter() & word().star()).flatten().map((value) => value);
  final nameWithNameSpace =
      (name & char(':') & name).flatten().map((value) => value);

  final varDef = undefined();
  final fnDef = undefined();
  final namespace = undefined();
  final namespaceStatement = (varDef | fnDef | namespace);
  final namespaceStatements = (namespaceStatement &
          (sp & newline() & ws & namespaceStatement)
              .map((value) => value[3])
              .star())
      .map((value) => [value[0], ...value[1]]);
  final ns = (string('::') &
          wsp &
          name &
          wsp &
          char('{') &
          ws &
          namespaceStatements.optional() &
          ws &
          char('}'))
      .map((value) => Namespace(value[2], value[6]));
  namespace.set(ns);
  final meta = undefined();
  final statement = undefined();
  final globalStatement = (namespace | meta | statement);
  final globalStatements = (globalStatement &
          (sp & newline() & ws & globalStatement)
              .map((value) => value[3])
              .star())
      .map((value) => [value[0], ...value[1]]);
  final statements = (statement &
          (sp & newline() & ws & statement).map((value) => value[3]).star())
      .map((value) => [value[0], ...value[1]]);
  final block = (char('{') & ws & statements.optional() & ws & char('}'))
      .map((value) => Block((value[2] as List<dynamic>? ?? []).cast<Node>()));
  final blockOrStatement = (block | statement);

  final main =
      (ws & globalStatements.optional() & ws).map((value) => value[1] ?? []);

  final parser = undefined();
  final numOperand = undefined();
  final boolOperand = undefined();
  final equatable = undefined();

  final num = number();
  final bool = boolean();
  final sl = str();
  final nul = string('null').map((_) => Literal(null, 'null'));
  final literal = (sl | num | bool | nul);

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

  final binaryBool = curlyBracket(compaarers | and | or);
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
      curlyBracket(minus | plus | multiply | divide | modulo | power);
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
  final expr2 = undefined();
  final infix = undefined();
  final expr3 = undefined();
  final type = undefined();

  // functioin definition

  final argument =
      (name & (ws & char(':') & ws & type).map((value) => value[3]).optional())
          .map((value) => Argument(value[0], value[1]));
  final arguments = argument &
      (separator & argument)
          .map((value) => value[1])
          .star()
          .map((value) => [value[0], ...value[1]]);
  final functionDefinition = (char('@') &
          sp &
          name & // 2
          sp &
          char('(') &
          ws &
          arguments.optional() & // 6
          ws &
          char(')') &
          (ws & char(':') & ws & type)
              .map((value) => value[3])
              .optional() & // 9
          ws &
          char('{') &
          ws &
          statements.optional() & // 13
          ws &
          char('}'))
      .map((value) => FunctionDefinition(
          value[2],
          FunctionNode(
              (value[6] ?? []).cast<Node>(), value[9], value[13].cast<Node>()),
          false));
  fnDef.set(functionDefinition);

  final function = (string('@(') &
          ws &
          arguments.optional() &
          ws &
          char(')') &
          (ws & char(':') & ws & type).map((value) => value[3]).optional() &
          ws &
          char('{') &
          ws &
          statements.optional() &
          ws &
          char('}'))
      .map((value) => FunctionNode(value[2] ?? [], value[5], value[9]));

  final variable =
      ((string('let').map((_) => false) | string('var').map((_) => true)) &
              sp &
              name &
              (ws & char(':') & ws & type).map((value) => value[3]).optional() &
              ws &
              char('=') &
              ws &
              expr)
          .map((values) =>
              ValuableDefinition(values[2], values[7], values[3], values[0]));
  varDef.set(variable);

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
  final output =
      (string('<:') & ws & expr).map((value) => Identifier('print').chains([
            CallChain([value[2]])
          ]));
  final ret = (string('return') & noneOf('A-Za-z0-9_:') & ws & expr)
      .map((value) => Return(value[3]));
  final brk = (string('break') & noneOf('A-Za-z0-9_:')).map((value) => Break());
  final ctn =
      (string('continue') & noneOf('A-Za-z0-9_:')).map((value) => Continue());

  final forFromToWithBrakets = (string('for') &
          ws &
          char('(') &
          string('let') &
          ws &
          name &
          ws &
          (char('=') & ws & expr).map((value) => value[2]).optional() &
          char(',').optional() &
          expr &
          char(')') &
          ws &
          blockOrStatement)
      .map((value) =>
          For(value[5], value[7] ?? Literal(0, 'num'), value[9], value[12]));
  final forFromTo = (string('for') &
          wsp &
          string('let') &
          ws &
          name &
          ws &
          (char('=') & ws & expr).map((value) => value[2]).optional() &
          char(',').optional() &
          expr &
          wsp &
          blockOrStatement)
      .map((value) =>
          For(value[4], value[6] ?? Literal(0, 'num'), value[8], value[10]));
  final forEach = (string('for') &
          ((wsp & expr & wsp).map((value) => value[1]) |
              (ws & char('(') & expr & char(')') & ws)
                  .map((value) => value[2])) &
          blockOrStatement)
      .map((value) => ForEach(value[1], value[2]));
  final each = (string('each') &
              ws &
              char('(') &
              string('let') &
              ws &
              name &
              ws &
              char(',').optional() &
              ws &
              expr &
              char(')') &
              ws &
              blockOrStatement)
          .map((value) => Each(value[5], value[9], value[12])) |
      (string('each') &
              wsp &
              string('let') &
              ws &
              name &
              ws &
              char(',').optional() &
              ws &
              expr &
              wsp &
              blockOrStatement)
          .map((value) => Each(value[4], value[8], value[10]));
  type.set(genericNamedType | primitiveNamedType | functionType);
  arrayItem.set(array | obj | boolOperand | numOperand | literal);
  propertyValue.set(array | obj | boolOperand | numOperand | literal);
  final loop =
      (string('loop') & ws & char('{') & ws & statements & ws & char('}'))
          .map((value) => Loop(value[4].cast<Node>()));

  final elseIfBlock = (string('elif') &
          noneOf('a-zA-Z0-9_:') &
          ws &
          expr &
          ws &
          blockOrStatement)
      .map((value) => (IfThen(value[3], value[5])));
  final elseIfBlocks =
      (elseIfBlock & (ws & elseIfBlock).map((value) => value[1]).star())
          .map((value) => [value[0], ...value[1]]);
  final elseBlock =
      (string("else") & noneOf('a-zA-Z0-9_:') & ws & blockOrStatement)
          .map((value) => value[3]);
  final ifThen = (string('if') &
          wsp &
          expr &
          wsp &
          blockOrStatement &
          (wsp & elseIfBlocks).map((value) => value[1]).optional() &
          (wsp & elseBlock).map((value) => value[1]).optional())
      .map((value) => If(value[2], value[4], value[5] ?? [], value[6]));

  final propChain = (char('.') & name).map((value) => PropertyChain(value[1]));
  final indexChain = (char('[') & ws & expr & ws & char(']'))
      .map((value) => IndexChain(value[2]));
  final callArgs = (expr & (separator & expr).map((value) => value[1]).star())
      .map((value) => [value[0], ...value[1]]);
  final callChain = (char('(') & ws & callArgs.optional() & ws & char(')'))
      .map((value) => CallChain(value[2] ?? []));
  final chain = (expr3 & (callChain | indexChain | propChain).plus())
      .map((value) => value[0].chains(value[1]));
  final assign = (expr &
          ws &
          (string('+=') | string('-=') | string('=')).map((value) => value) &
          ws &
          expr)
      .map((value) {
    final op = value[2];
    final dest = value[0];
    final expr = value[4];
    if (op == '+=') return AddAssign(dest, expr);
    if (op == '-=') return SubAssign(dest, expr);
    return Assign(dest, expr);
  });
  final not = (char('!') & expr).map((value) => Not(value[1]));
  statement.set(varDef |
      fnDef |
      output |
      ret |
      each |
      forFromTo |
      forFromToWithBrakets |
      forEach |
      loop |
      brk |
      ctn |
      assign |
      expr);
  expr.set(infix | expr2);
  expr2.set(ifThen | function | chain | expr3);
  expr3.set(boolOperand |
      numOperand |
      literal |
      obj |
      array |
      not |
      identifier |
      curlyBracket(expr));

  parser.set(main.map((value) => value.cast<Node>()));

  return parser.parse(text).value as Iterable<Node>;
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
