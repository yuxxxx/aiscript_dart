import 'package:aiscript_dart/exceptions/errors.dart';
import 'package:aiscript_dart/parser/core/node.dart';

final reservedWord = [
  'null',
  'true',
  'false',
  'each',
  'for',
  'loop',
  'break',
  'continue',
  'match',
  'if',
  'elif',
  'else',
  'return',
  'eval',
  'var',
  'let',

  // future
  'fn',
  'namespace',
  'meta',
  'attr',
  'attribute',
  'static',
  'class',
  'struct',
  'module',
  'while',
  'import',
  'export',
  // 'const',
  // 'def',
  // 'func',
  // 'function',
  // 'ref',
  // 'out',
];

void throwReservedWordError(String name) {
  throw SyntaxError('Reserved word "$name" cannot be used as variable name.');
}

Node validateNode(Node node) {
  switch (node) {
    case FunctionTypeDefinition fn:
      {
        for (var arg in fn.args) {
          if (reservedWord.contains(arg.name)) {
            throwReservedWordError(arg.name);
          }
        }
        break;
      }
    case Naming naming:
      {
        if (reservedWord.contains(naming.name)) {
          throwReservedWordError(naming.name);
        }
        break;
      }
    // case 'meta':
    //   {
    //     if (node.name != null && reservedWord.contains(node.name)) {
    //       throwReservedWordError(node.name);
    //     }
    //     break;
    //   }
  }

  return node;
}
