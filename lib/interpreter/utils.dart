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
