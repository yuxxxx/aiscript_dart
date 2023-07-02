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

class Definition<T> implements ValuedNode<T> {
  @override
  get value => _value.value;
  final ValuedNode<T> _value;

  @override
  get type => 'def';

  String get name => _name;
  final String _name;

  bool get mutable => _mutable;
  final bool _mutable;

  TypeDefinition? get varType => _varType;
  final TypeDefinition? _varType;

  Definition(this._name, this._value, this._varType, this._mutable);

  @override
  operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Definition) {
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

class Identifier implements Node {
  @override
  get type => 'identifier';

  get name => _name;
  final String _name;

  Identifier(this._name);

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
