import 'dart:math';

import 'node.dart';

abstract class BinaryOperator<TLeft, TRight, TResult>
    implements ValuedNode<TResult> {
  final ValuedNode<TLeft> left;
  final ValuedNode<TRight> right;
  @override
  get type => 'infix';
  BinaryOperator(this.left, this.right);
}

class Minus extends BinaryOperator<num, num, num> {
  @override
  get value => left.value - right.value;
  Minus(ValuedNode<num> left, ValuedNode<num> right) : super(left, right);
}

class Plus extends BinaryOperator<num, num, num> {
  @override
  get value => left.value + right.value;
  Plus(ValuedNode<num> left, ValuedNode<num> right) : super(left, right);
}

class Multiply extends BinaryOperator<num, num, num> {
  @override
  get value => left.value * right.value;
  Multiply(ValuedNode<num> left, ValuedNode<num> right) : super(left, right);
}

class Divide extends BinaryOperator<num, num, num> {
  @override
  get value => left.value / right.value;
  Divide(ValuedNode<num> left, ValuedNode<num> right) : super(left, right);
}

class Modulo extends BinaryOperator<num, num, num> {
  @override
  get value => left.value % right.value;
  Modulo(ValuedNode<num> left, ValuedNode<num> right) : super(left, right);
}

class Power extends BinaryOperator<num, num, num> {
  @override
  get value => pow(left.value, right.value);
  Power(ValuedNode<num> left, ValuedNode<num> right) : super(left, right);
}

class Equal<TLeft, TRight> extends BinaryOperator<TLeft, TRight, bool> {
  @override
  get value => left.value == right.value;
  Equal(ValuedNode<TLeft> left, ValuedNode<TRight> right) : super(left, right);
}

class NotEqual<TLeft, TRight> extends BinaryOperator<TLeft, TRight, bool> {
  @override
  get value => left.value != right.value;
  NotEqual(ValuedNode<TLeft> left, ValuedNode<TRight> right)
      : super(left, right);
}

class LessThan extends BinaryOperator<num, num, bool> {
  @override
  get value => left.value > right.value;
  LessThan(ValuedNode<num> left, ValuedNode<num> right) : super(left, right);
}

class GreaterThan extends BinaryOperator<num, num, bool> {
  @override
  get value => left.value < right.value;
  GreaterThan(ValuedNode<num> left, ValuedNode<num> right) : super(left, right);
}

class And extends BinaryOperator<bool, bool, bool> {
  @override
  get value => left.value && right.value;
  And(ValuedNode<bool> left, ValuedNode<bool> right) : super(left, right);
}

class Or extends BinaryOperator<bool, bool, bool> {
  @override
  get value => left.value || right.value;
  Or(ValuedNode<bool> left, ValuedNode<bool> right) : super(left, right);
}
