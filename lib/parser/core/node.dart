import 'package:aiscript_dart/parser/utils/items_equal.dart';

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

class Literal<T> extends Chainable implements ValuedNode<T> {
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

  @override
  operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is FunctionDefinition) {
      return name == other.name && expression == other.expression;
    }
    return false;
  }
}

class FunctionNode with Chainable implements Node {
  @override
  get type => 'fn';

  Iterable<Node> get arguments => _arguments;
  final Iterable<Node> _arguments;

  TypeDefinition? get retType => _retType;
  final TypeDefinition? _retType;

  Iterable<Node> get content => _content;
  final Iterable<Node> _content;

  FunctionNode(this._arguments, this._retType, this._content);

  @override
  operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is FunctionNode) {
      return arguments.everyEquals(other.arguments) &&
          content.everyEquals(other.content) &&
          retType == other.retType;
    }
    return false;
  }
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

class Each implements Node {
  @override
  get type => 'each';

  String get variant => _variant;
  final String _variant;

  Node get items => _items;
  final Node _items;

  Node get iteration => _iteration;
  final Node _iteration;

  Each(this._variant, this._items, this._iteration);

  @override
  operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is Each) {
      return variant == other.variant &&
          iteration == other.iteration &&
          items == other.items;
    }
    return false;
  }

  @override
  String toString() {
    return 'Each: $variant: [$items]{ $iteration }';
  }
}

class Loop implements Node {
  @override
  get type => 'loop';

  Iterable<Node> get statements => _statements;
  final Iterable<Node> _statements;

  Loop(this._statements);

  @override
  operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is CallChain) {
      return statements.everyEquals(statements);
    }
    return false;
  }

  @override
  String toString() {
    return 'Loop: { ${statements.join(",")} }';
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
      return statements.everyEquals(statements);
    }
    return false;
  }

  @override
  String toString() {
    return 'block: { ${statements.join(';')} }';
  }
}

class Identifier with Chainable implements Node {
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
      return name == other.name && chain.everyEquals(chain);
    }
    return false;
  }

  @override
  String toString() {
    return 'Identifier: $name, chain: ${chain.join(",")}';
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
  operator ==(Object other) {
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

  Iterable<Node> get args => _args;
  final List<Node> _args;

  CallChain(this._args);

  @override
  operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is CallChain) {
      return args.everyEquals(args);
    }
    return false;
  }

  @override
  String toString() {
    return 'CallChain: [${args.join(",")}]';
  }
}

class IndexChain implements Node {
  @override
  get type => 'callChain';

  Node get index => _index;
  final Node _index;

  IndexChain(this._index);

  @override
  operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is IndexChain) {
      return index == other.index;
    }
    return false;
  }

  @override
  String toString() {
    return 'IndexChain: [$index]';
  }
}

class PropertyChain implements Node {
  @override
  get type => 'callChain';

  String get name => _name;
  final String _name;

  PropertyChain(this._name);

  @override
  operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is PropertyChain) {
      return name == other.name;
    }
    return false;
  }

  @override
  String toString() {
    return 'IndexChain: .$name';
  }
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

class IfThen {
  Node get cond => _cond;
  final Node _cond;

  Node get then => _then;
  final Node _then;

  IfThen(this._cond, this._then);
}

class If extends IfThen with Chainable implements Node {
  @override
  get type => 'if';

  Iterable<IfThen> get elseIf => _elseIf;
  final Iterable<IfThen> _elseIf;

  Node? get els => _els;
  final Node? _els;

  If(Node cond, Node then, this._elseIf, this._els) : super(cond, then);

  @override
  operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is If) {
      return cond == other.cond &&
          then == other.then &&
          elseIf.everyEquals(other.elseIf);
    }
    return false;
  }
}

class Assign implements Node {
  @override
  get type => 'assign';

  Node get dest => _dest;
  final Node _dest;

  Node get expression => _expression;
  final Node _expression;

  Assign(this._dest, this._expression);

  @override
  operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is Assign) {
      return dest == other.dest && expression == other.expression;
    }
    return false;
  }
}

class AddAssign extends Assign {
  @override
  get type => 'addAssign';

  AddAssign(dest, expr) : super(dest, expr);
}

class SubAssign extends Assign {
  @override
  get type => 'subAssign';

  SubAssign(dest, expr) : super(dest, expr);
}

class Not implements Node {
  @override
  get type => 'subAssign';

  Node get expression => _expression;
  final Node _expression;

  Not(this._expression);
}

mixin class Chainable {
  Iterable<Node> get chain => _chain;
  final List<Node> _chain = [];

  Chainable chains(Iterable<Node> chain) {
    _chain.addAll(chain);
    return this;
  }
}
