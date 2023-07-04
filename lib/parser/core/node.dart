abstract class Node {
  String get type;
  Node();

  @override
  String toString() {
    return 'Node';
  }
}

abstract class ValuedNode<T> extends Node {
  T get value;
  ValuedNode();
}

class Literal<T> implements ValuedNode<T> {
  @override
  get type => this._type;
  final String _type;

  @override
  get value => this._value;
  final T _value;

  Literal(this._value, this._type);

  @override
  toString() {
    return 'Literal<$type>: $value';
  }
}

abstract class Definition implements Node {
  @override
  get type => 'def';

  String get name => _name;
  final String _name;

  bool get mutable => _mutable;
  final bool _mutable;

  Definition(this._name, this._mutable);
}

class ValuableDefinition<T> extends Definition implements ValuedNode<T> {
  @override
  get value => _value.value;
  final ValuedNode<T> _value;

  TypeDefinition? get varType => _varType;
  final TypeDefinition? _varType;

  ValuableDefinition(name, this._value, this._varType, mutable)
      : super(name, mutable);

  @override
  operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is ValuableDefinition) {
      return name == other.name &&
          mutable == other.mutable &&
          varType == other.varType;
    }
    return false;
  }

  @override
  toString() {
    return 'Definition: $name<($varType)> mutable: $mutable';
  }
}

class FunctionDefinition extends Definition {
  FunctionNode get expression => _expression;
  final FunctionNode _expression;
  FunctionDefinition(name, this._expression, mutable) : super(name, mutable);
}

class FunctionNode implements Node {
  @override
  get type => 'fn';

  Iterable<dynamic> get arguments => _arguments;
  final Iterable<dynamic> _arguments;

  TypeDefinition get retType => _retType;
  final TypeDefinition _retType;

  Iterable<dynamic> get content => _content;
  final Iterable<dynamic> _content;

  FunctionNode(this._arguments, this._retType, this._content);
}

class Identifier implements Node {
  @override
  get type => 'identifier';

  get name => _name;
  final String _name;

  Iterable<Node> get chain => _chain;
  final List<Node> _chain = [];

  Identifier(this._name);
  Identifier.chained(this._name, Iterable<Node> chain) {
    _chain.addAll(chain);
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Identifier) {
      return name == other.name;
    }
    return false;
  }

  @override
  String toString() {
    return 'Identifier: $name';
  }
}

abstract class TypeDefinition extends Node {
  String get name;
}

class NamedTypeDefinition implements TypeDefinition {
  @override
  get type => 'namedTypeSource';

  @override
  get name => _name;
  final String _name;

  get inner => _inner;
  final NamedTypeDefinition? _inner;

  NamedTypeDefinition(this._name, this._inner);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is NamedTypeDefinition) {
      return name == other.name && inner == other.inner;
    }
    return false;
  }
}

class FunctionTypeDefinition implements TypeDefinition {
  @override
  get type => 'fnTypeSource';
  @override
  get name => 'fn';
  List<TypeDefinition> get args => _args;
  final List<TypeDefinition> _args;
  TypeDefinition get result => _result;
  final TypeDefinition _result;
  FunctionTypeDefinition(this._args, this._result);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is FunctionTypeDefinition) {
      return args.asMap().keys.every((i) => args[i] == other.args[i]) &&
          result == other.result;
    }
    return false;
  }
}

class CallChain implements Node {
  @override
  get type => 'callChain';

  get args => _args;
  final List<ValuedNode<dynamic>> _args;

  CallChain(this._args);
}

class Namespace implements Node {
  @override
  get type => 'ns';

  String get name => _name;
  final String _name;

  Iterable<dynamic> get members => _members ?? [];
  final Iterable<dynamic>? _members;

  Namespace(this._name, this._members);
}

class Argument {
  String get name => _name;
  final String _name;

  TypeDefinition get argType => _argType;
  final TypeDefinition _argType;

  Argument(this._name, this._argType);
}
