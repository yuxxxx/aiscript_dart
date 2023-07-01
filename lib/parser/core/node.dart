abstract class Node<T> {
  String get name;
  Node();
}

abstract class ValuedNode<T> extends Node {
  T get value;
  ValuedNode();
}

class Literal<T> implements ValuedNode<T> {
  @override
  String get name => this._name;
  @override
  T get value => this._value;
  final String _name;
  final T _value;
  Literal(this._value, this._name);
}

class Array<T> implements ValuedNode<Iterable<T>> {
  @override
  get name => 'array';
  @override
  get value => values.map((value) => value.value);
  Iterable<ValuedNode<T>> values;
  Array(this.values);
}

class Definition<T> implements ValuedNode<T> {
  @override
  get value => _value.value;
  @override
  get name => _name;
  final String _name;
  final ValuedNode<T> _value;
  Definition(this._name, this._value);
}

class Identifier<T> implements Node<T> {
  @override
  get name => _name;
  final String _name;
  Identifier(this._name);
}
