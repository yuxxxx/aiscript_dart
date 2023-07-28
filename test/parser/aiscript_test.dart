import 'package:aiscript_dart/main.dart' as ai;
import 'package:aiscript_dart/parser/core/node.dart';
import 'package:test/test.dart';

ValuedNode<dynamic> parseValue(text) =>
    ai.Parser.parseInput(text).first as ValuedNode<dynamic>;

void main() {
  test('parse add', () {
    expect(parseValue('(1 + 2)').value, 3);
  });

  test('parse minus', () {
    expect(parseValue('(1 - 2)').value, -1);
  });

  test('parse multiple', () {
    expect(parseValue('(1 + (2 * 3))').value, 7);
  });

  test('parse power', () {
    expect(parseValue('(10 ^ 2)').value, 100);
  });

  test('parse modulo', () {
    expect(parseValue('(13 % 5)').value, 3);
  });

  test('parse div', () {
    expect(parseValue('(1 / 2)').value, 0.5);
  });

  test('parse div0', () {
    expect(parseValue('(1 / 0)').value, double.infinity);
  });

  test('parse div00', () {
    expect(parseValue('(0 / 0)').value, isNaN);
  });

  test('parse compare lt', () {
    expect(parseValue('(3 > 2)').value, true);
  });

  test('parse compare gt', () {
    expect(parseValue('(2 < 3)').value, true);
  });

  test('parse compare eq number', () {
    expect(parseValue('(2 == 3)').value, false);
  });

  test('parse eq string', () {
    expect(parseValue('("2e" == "2e")').value, true);
  });

  test('parse compare ne number', () {
    expect(parseValue('(2 != 3)').value, true);
  });

  test('parse ne string', () {
    expect(parseValue('("2e" != "2e")').value, false);
  });

  test('parse and', () {
    expect(parseValue('(true && false)').value, false);
  });

  test('parse or', () {
    expect(parseValue('(true || false)').value, true);
  });

  test('parse string', () {
    expect(parseValue('"text"').value, 'text');
  });
  test('parse blank string', () {
    expect(parseValue('""').value, '');
  });

  test('parse escaped string', () {
    expect(parseValue('"\\"test\\""').value, '"test"');
  });

  test('parse single quote blank string', () {
    expect(parseValue("''").value, '');
  });
  test('parse escaped single quote string', () {
    expect(parseValue("'\\'test\\''").value, "'test'");
  });

  test('parse integer', () {
    expect(parseValue('42').value, 42);
  });

  test('parse negative integer', () {
    expect(parseValue('-2').value, -2);
  });

  test('parse real', () {
    expect(parseValue('4.2').value, 4.2);
  });

  test('parse negative real', () {
    expect(parseValue('-42.2').value, -42.2);
  });

  test('parse boolean', () {
    expect(parseValue('true').value, true);
  });

  test('complex compare boolean', () {
    expect(parseValue('((3 > 1) && true)').value, true);
  });

  test('complex binary binary bool', () {
    expect(parseValue('((3 < 1) || (2 == 1))').value, false);
  });

  test('complex binary binary calculate', () {
    expect(parseValue('((3 + 1) * (2 - 1))').value, 4);
  });

  test('complex compare condition', () {
    expect(parseValue('((3 != 1) && ("2" == "3"))').value, false);
  });

  test('parse single item array', () {
    expect(parseValue('[1]').value, [1]);
  });

  test('parse multiple items array', () {
    expect(parseValue('[1 "2"]').value, [1, "2"]);
  });

  test('parse nested array', () {
    expect(parseValue('[1 2 [1 2]]').value, [
      1,
      2,
      [1, 2]
    ]);
  });

  test('parse computed array', () {
    expect(parseValue('[(1 == 2) (2 + 3) [1 2]]').value, [
      false,
      5,
      [1, 2]
    ]);
  });

  test('parse break-line empty array', () {
    expect(parseValue('''[

    ]''').value, []);
  });

  test('parse break-line single item array', () {
    expect(parseValue('''[
      2
    ]''').value, [2]);
  });

  test('parse break-line multiple items array', () {
    expect(parseValue('''[
      true
      2
    ]''').value, [true, 2]);
  });

  test('parse empty array', () {
    expect(parseValue('[]').value, []);
  });

  test('parse null', () {
    expect(parseValue('null').value, null);
  });

  test('parse empty object', () {
    expect(parseValue('{}').value, {});
  });

  test('parse one property object', () {
    expect(parseValue('{ hello: 2 }').value, ({'hello': 2}));
  });

  test('parse two properties object', () {
    expect(parseValue('{ hello: 2; world: false }').value,
        ({'hello': 2, 'world': false}));
  });

  test('parse multiple properties object', () {
    expect(
        parseValue('{ hello: "2"; world: null; foo: [1] }').value,
        ({
          'hello': "2",
          'world': null,
          'foo': [1]
        }));
  });

  test('parse nested properties object', () {
    expect(
        parseValue('{ hello: { world: "ai" } }').value,
        ({
          'hello': {'world': 'ai'}
        }));
  });

  test('parse break-line form empty object', () {
    expect(parseValue('''{ 
         }''').value, ({}));
  });

  test('parse break-line form object', () {
    expect(parseValue('''{
      hello: "world"
         }''').value, ({'hello': 'world'}));
  });

  test('parse break-line form multiple object', () {
    expect(parseValue('''{
      hello: "world";
      test: true;
         }''').value, ({'hello': 'world', 'test': true}));
  });

  test('parse break-line form nested array', () {
    expect(
        parseValue('''[
         {hello: "world"}
          [2]
         [true]
         {result: [null] }]''').value,
        ([
          {'hello': 'world'},
          [2],
          [true],
          {
            'result': [null]
          }
        ]));
  });
}
