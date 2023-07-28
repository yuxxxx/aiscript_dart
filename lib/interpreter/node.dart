import 'dart:async';

import 'package:aiscript_dart/interpreter/scope.dart';
import 'package:aiscript_dart/parser/core/node.dart';

abstract class VNode {}

class Vfn {
  final Iterable<String> args;
  final Iterable<Node> statements;
  final FutureOr<Value> Function(
    Iterable<Value> args,
  ) native;
  final Scope scope;

  Vfn(this.args, this.statements, this.native, this.scope);

  toFnNative() {
    return FnNative(native);
  }

  toFn() {
    return Fn(args, statements, scope);
  }
}

class Fn {
  final Iterable<String> args;
  final Iterable<Node> statements;
  final Scope scope;

  Fn(this.args, this.statements, this.scope);
}

class FnNative extends VNode {
  final FutureOr<Value> Function(
    Iterable<Value> args,
  ) native;
  FnNative(this.native);
}

abstract class Value extends VNode {
  String get type;
  get value;
}

class Str extends Value {
  @override
  get type => 'str';

  @override
  String get value => _value;
  final String _value;

  Str(this._value);
}

class Nul extends Value {
  @override
  get type => 'null';
  @override
  Null get value => null;
}

class VReturn extends Value {
  @override
  get type => 'return';
  @override
  get value => _value;
  final dynamic _value;

  VReturn(this._value);
}
