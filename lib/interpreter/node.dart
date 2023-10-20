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

  @override
  operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is Value) {
      return type == other.type && value == other.value;
    }
    return false;
  }

  @override
  String toString() {
    return '{ type: $type, val: $value }';
  }
}

class Str extends Value {
  @override
  get type => 'str';

  @override
  String get value => _value;
  final String _value;

  Str(this._value);
}

class Num extends Value {
  @override
  get type => 'num';
  @override
  num get value => _value;
  final num _value;
  Num(this._value);
}

class Bool extends Value {
  @override
  get type => 'bool';
  @override
  bool get value => _value;
  final bool _value;
  Bool(this._value);
}

class Nul extends Value {
  @override
  get type => 'null';
  @override
  Null get value => null;
}

class Arr extends Value {
  @override
  get type => 'arr';
  @override
  Iterable<dynamic> get value => _value;
  final Iterable<dynamic> _value;
  Arr(this._value);
}

class VReturn extends Value {
  @override
  get type => 'return';
  @override
  get value => _value;
  final dynamic _value;

  VReturn(this._value);
}
