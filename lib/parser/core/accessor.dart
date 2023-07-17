import 'package:aiscript_dart/parser/core/node.dart';

class Property implements Node {
  @override
  get type => 'prop';

  String get name => _name;
  final String _name;

  Node get target => _target;
  final Node _target;

  Property(this._target, this._name);
}

class Index implements Node {
  @override
  get type => 'prop';

  Node get index => _index;
  final Node _index;

  Node get target => _target;
  final Node _target;

  Index(this._target, this._index);
}

class Call implements Node {
  @override
  get type => 'prop';

  Iterable<Node> get args => _args;
  final Iterable<Node> _args;

  Node get target => _target;
  final Node _target;

  Call(this._target, this._args);
}
