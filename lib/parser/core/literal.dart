abstract class Node<T> {
  T value();
  Node();
}

class Literal<T> implements Node<T> {
  @override
  T value() => this._value;
  final T _value;
  Literal(this._value);
}

class Array<T> implements Node<Iterable<T>> {
  @override
  Iterable<T> value() => values.map((value) => value.value());
  Iterable<Node<T>> values;
  Array(this.values);
}
