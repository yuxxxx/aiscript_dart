import 'package:aiscript_dart/parser/core/node.dart';
import 'package:aiscript_dart/parser/utils/items_equal.dart';

class Property implements Node {
  @override
  get type => 'prop';

  String get name => _name;
  final String _name;

  Node target;

  Property(this.target, this._name);

  @override
  operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is Property) {
      return name == other.name && target == other.target;
    }
    return false;
  }
}

class Index implements Node {
  @override
  get type => 'prop';

  Node get index => _index;
  final Node _index;

  Node get target => _target;
  final Node _target;

  Index(this._target, this._index);

  @override
  operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is Index) {
      return index == other.index && target == other.target;
    }
    return false;
  }

  @override
  String toString() {
    return '$target[$index]';
  }
}

class Call implements Node {
  @override
  get type => 'prop';

  Iterable<Node> get args => _args;
  final Iterable<Node> _args;

  Node get target => _target;
  final Node _target;

  Call(this._target, this._args);

  @override
  operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is Call) {
      return args.everyEquals(other.args) && target == other.target;
    }
    return false;
  }
}
