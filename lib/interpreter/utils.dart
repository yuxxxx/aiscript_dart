import 'package:aiscript_dart/exceptions/errors.dart';
import 'package:aiscript_dart/interpreter/node.dart';

dynamic expectAny(dynamic value) {
  if (value == null) {
    throw RuntimeError('Expect anything, but got nothing.');
  }
  return value;
}

Str assertString(dynamic value) {
  if (value == null) {
    throw RuntimeError('Expect string, but got nothing.');
  }

  if (value is Str) {
    return value;
  }
  throw RuntimeError('Expect string, but got ${value.type}');
}

Bool assertBoolean(dynamic value) {
  if (value == null) {
    throw RuntimeError('Expect boolean, but got nothing');
  }
  if (value is Bool) {
    return value;
  }
  throw RuntimeError('Expect boolean, but got ${value.type}');
}

Num assertNumber(dynamic value) {
  if (value == null) {
    throw RuntimeError('Expect number, but got nothing');
  }
  if (value is Num) {
    return value;
  }
  throw RuntimeError('Expect number, but got ${value.type}');
}
