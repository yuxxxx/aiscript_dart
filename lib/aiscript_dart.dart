import 'package:petitparser/petitparser.dart';

int calculate() {
  return 6 * 7;
}

dynamic parseNumber(text) {
  final integer = digit().plus().flatten().trim().map(int.parse);
  final real = (digit().plus() & char('.') & digit().plus())
      .flatten()
      .trim()
      .map(double.parse);
  final number = (real | integer);

  final term = undefined();
  final prod = undefined();
  final prim = undefined();

  final minus =
      (prod & char('-').trim() & term).map((values) => values[0] - values[2]);
  final add =
      (prod & char('+').trim() & term).map((values) => values[0] + values[2]);
  term.set(add | minus | prod);

  final mul =
      (prim & char('*').trim() & prod).map((values) => values[0] * values[2]);
  final div =
      (prim & char('/').trim() & prod).map((values) => values[0] / values[2]);
  prod.set(mul | div | prim);

  final parens =
      (char('(').trim() & term & char(')').trim()).map((values) => values[1]);
  prim.set(parens | number);
  final parser = term.end();
  return parser.parse(text).value;
}

dynamic parseCompare(text) {
  final integer = digit().plus().flatten().trim().map(int.parse);
  final real = (digit().plus() & char('.') & digit().plus())
      .flatten()
      .trim()
      .map(double.parse);
  final number = (real | integer);
  final letters = (char('"') & word().plus().flatten() & char('"'))
      .map((values) => values[1] as String);
  final term = undefined();

  final lt = (number & char('>').trim() & number)
      .map((values) => values[0] > values[2]);

  final gt = (number & char('<').trim() & number)
      .map((values) => values[0] < values[2]);

  final equatable = (number | letters);
  final eq = (equatable & string('==').trim() & equatable)
      .map((values) => values[0] == values[2]);

  final ne = (equatable & string('!=').trim() & equatable)
      .map((values) => values[0] != values[2]);

  term.set(eq | ne | lt | gt | equatable);
  final parser = term.end();

  return parser.parse(text).value;
}
