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
  operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is Literal<T>) {
      return value == other.value && type == other.type;
    }
    return false;
  }

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

  Iterable<Node> get arguments => _arguments;
  final Iterable<Node> _arguments;

  TypeDefinition get retType => _retType;
  final TypeDefinition _retType;

  Iterable<Node> get content => _content;
  final Iterable<Node> _content;

  FunctionNode(this._arguments, this._retType, this._content);
}

class For implements Node {
  @override
  String get type => 'for';

  Node get variable => _variable;
  final Node _variable;

  Node get from => _from;
  final Node _from;

  Node get to => _to;
  final Node _to;

  Node get iteration => _iteration;
  final Node _iteration;

  For(this._variable, this._from, this._to, this._iteration);
}

class ForEach implements Node {
  @override
  String get type => 'for';

  Node get times => _times;
  final Node _times;

  Node get iteration => _iteration;
  final Node _iteration;

  ForEach(this._times, this._iteration);

  @override
  operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is ForEach) {
      return times == other.times && iteration == other.iteration;
    }
    return false;
  }

  @override
  String toString() {
    return 'ForEach: ($times) $iteration';
  }
}

class Return implements Node {
  @override
  get type => 'return';

  Node get expression => _expression;
  final Node _expression;

  Return(this._expression);

  @override
  operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is Return) {
      return expression == other.expression;
    }
    return false;
  }
}

class Break implements Node {
  @override
  get type => 'break';

  Break();

  @override
  operator ==(dynamic other) {
    return identical(this, other) || other is Break;
  }
}

class Continue implements Node {
  @override
  get type => 'continue';

  Continue();

  operator ==(dynamic other) {
    return identical(this, other) || other is Continue;
  }
}

class Block implements Node {
  @override
  get type => 'block';

  Iterable<Node> get statements => _statements;
  final Iterable<Node> _statements;

  Block(this._statements);

  @override
  operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is Block) {
      return statements.indexed
          .every((i) => i.$2 == other.statements.elementAt(i.$1));
    }
    return false;
  }

  @override
  String toString() {
    return 'block: { ${statements.join(';')} }';
  }
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

  Iterable<Node> get members => _members ?? [];
  final Iterable<Node>? _members;

  Namespace(this._name, this._members);
}

class Argument {
  String get name => _name;
  final String _name;

  TypeDefinition get argType => _argType;
  final TypeDefinition _argType;

  Argument(this._name, this._argType);
}
