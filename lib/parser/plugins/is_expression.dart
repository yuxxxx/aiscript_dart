import 'package:aiscript_dart/parser/core/node.dart';

extension IsExpressionExtension on Node {
  static final expressionTypes = [
    'infix',
    'if',
    'fn',
    'match',
    'block',
    'tmpl',
    'str',
    'num',
    'bool',
    'null',
    'obj',
    'arr',
    'identifier',
    'call',
    'index',
    'prop',
  ];
  bool isExpression() {
    return expressionTypes.contains(type);
  }
}
