import 'package:aiscript_dart/aiscript.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(calculate(), 42);
  });

  test('parse add', () {
    expect(parseNumber('1 + 2'), 3);
  });

  test('parse minus', () {
    expect(parseNumber('1 - 2'), -1);
  });

  test('parse multiple', () {
    expect(parseNumber('1 + 2 * 3'), 7);
  });

  test('parse div', () {
    expect(parseNumber('1 / 2'), 0.5);
  });

  test('parse div0', () {
    expect(parseNumber('1 / 0'), double.infinity);
  });

  test('parse div00', () {
    expect(parseNumber('0 / 0'), isNaN);
  });

  test('parse compare lt', () {
    expect(parseCompare('3 > 2'), true);
  });

  test('parse compare gt', () {
    expect(parseCompare('2 < 3'), true);
  });

  test('parse compare eq number', () {
    expect(parseCompare('2 == 3'), false);
  });

  test('parse eq string', () {
    expect(parseCompare('"2e" == "2e"'), true);
  });

  test('parse compare ne number', () {
    expect(parseCompare('2 != 3'), true);
  });

  test('parse ne string', () {
    expect(parseCompare('"2e" != "2e"'), false);
  });

  test('parse string', () {
    expect(parseCompare('"text"'), 'text');
  });

  test('parse integer', () {
    expect(parseCompare('42'), 42);
  });

  test('parse real', () {
    expect(parseCompare('4.2'), 4.2);
  });
}
