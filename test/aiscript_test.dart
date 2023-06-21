import 'package:aiscript_dart/aiscript.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(calculate(), 42);
  });

  test('parse add', () {
    expect(parse('(1 + 2)').value(), 3);
  });

  test('parse minus', () {
    expect(parse('(1 - 2)').value(), -1);
  });

  test('parse multiple', () {
    expect(parse('(1 + (2 * 3))').value(), 7);
  });

  test('parse power', () {
    expect(parse('(10 ^ 2)').value(), 100);
  });

  test('parse modulo', () {
    expect(parse('(13 % 5)').value(), 3);
  });

  test('parse div', () {
    expect(parse('(1 / 2)').value(), 0.5);
  });

  test('parse div0', () {
    expect(parse('(1 / 0)').value(), double.infinity);
  });

  test('parse div00', () {
    expect(parse('(0 / 0)').value(), isNaN);
  });

  test('parse compare lt', () {
    expect(parse('(3 > 2)').value(), true);
  });

  test('parse compare gt', () {
    expect(parse('(2 < 3)').value(), true);
  });

  test('parse compare eq number', () {
    expect(parse('(2 == 3)').value(), false);
  });

  test('parse eq string', () {
    expect(parse('("2e" == "2e")').value(), true);
  });

  test('parse compare ne number', () {
    expect(parse('(2 != 3)').value(), true);
  });

  test('parse ne string', () {
    expect(parse('("2e" != "2e")').value(), false);
  });

  test('parse and', () {
    expect(parse('(true && false)').value(), false);
  });

  test('parse or', () {
    expect(parse('(true || false)').value(), true);
  });

  test('parse string', () {
    expect(parse('"text"').value(), 'text');
  });

  test('parse integer', () {
    expect(parse('42').value(), 42);
  });

  test('parse real', () {
    expect(parse('4.2').value(), 4.2);
  });

  test('parse boolean', () {
    expect(parse('true').value(), true);
  });

  test('complex compare boolean', () {
    expect(parse('((3 > 1) && true)').value(), true);
  });

  test('complex binary binary bool', () {
    expect(parse('((3 < 1) || (2 == 1))').value(), false);
  });

  test('complex binary binary calculate', () {
    expect(parse('((3 + 1) * (2 - 1))').value(), 4);
  });

  test('complex compare condition', () {
    expect(parse('((3 != 1) && ("2" == "3"))').value(), false);
  });

  test('parse array', () {
    expect(parse('[1]').value(), [1]);
  });

  test('parse array', () {
    expect(parse('[1, "2"]').value(), [1, "2"]);
  });

  test('parse nested array', () {
    expect(parse('[1, 2, [1, 2]]').value(), [
      1,
      2,
      [1, 2]
    ]);
  });

  test('parse complex array', () {
    expect(parse('[(1 == 2), (2 + 3), [1, 2]]').value(), [
      false,
      5,
      [1, 2]
    ]);
  });

  test('parse empty array', () {
    expect(parse('[]').value(), []);
  });

  test('parse null', () {
    expect(parse('null').value(), null);
  });

  test('parse empty object', () {
    expect(parse('{}').value(), {});
  });

  test('parse one property object', () {
    expect(parse('{ hello: 2 }').value(), ({'hello': 2}));
  });

  test('parse two properties object', () {
    expect(parse('{ hello: 2; world: false }').value(),
        ({'hello': 2, 'world': false}));
  });

  test('parse multiple properties object', () {
    expect(
        parse('{ hello: "2"; world: null; foo: [1] }').value(),
        ({
          'hello': "2",
          'world': null,
          'foo': [1]
        }));
  });

  test('parse nested properties object', () {
    expect(
        parse('{ hello: { world: "ai" } }').value(),
        ({
          'hello': {'world': 'ai'}
        }));
  });

  test('parse break-line form empty object', () {
    expect(parse('''{ 
         }''').value(), ({}));
  });

  test('parse break-line form object', () {
    expect(parse('''{
      hello: "world"
         }''').value(), ({'hello': 'world'}));
  });
}
