import 'dart:math';

import 'literal.dart';

abstract class BinaryOperator<TLeft, TRight, TResult> implements Node<TResult> {
  final Node<TLeft> left;
  final Node<TRight> right;
  BinaryOperator(this.left, this.right);
}

class Minus extends BinaryOperator<num, num, num> {
  @override
  num value() => left.value() - right.value();
  Minus(left, right) : super(left, right);
}

class Plus extends BinaryOperator<num, num, num> {
  @override
  num value() => left.value() + right.value();
  Plus(left, right) : super(left, right);
}

class Multiply extends BinaryOperator<num, num, num> {
  @override
  num value() => left.value() * right.value();
  Multiply(left, right) : super(left, right);
}

class Divide extends BinaryOperator<num, num, num> {
  @override
  num value() => left.value() / right.value();
  Divide(left, right) : super(left, right);
}

class Modulo extends BinaryOperator<num, num, num> {
  @override
  num value() => left.value() % right.value();
  Modulo(left, right) : super(left, right);
}

class Power extends BinaryOperator<num, num, num> {
  @override
  num value() => pow(left.value(), right.value());
  Power(left, right) : super(left, right);
}

class Equal<TLeft, TRight> extends BinaryOperator<TLeft, TRight, bool> {
  @override
  bool value() => left.value() == right.value();
  Equal(left, right) : super(left, right);
}

class NotEqual<TLeft, TRight> extends BinaryOperator<TLeft, TRight, bool> {
  @override
  bool value() => left.value() != right.value();
  NotEqual(left, right) : super(left, right);
}

class LessThan extends BinaryOperator<num, num, bool> {
  @override
  bool value() => left.value() > right.value();
  LessThan(left, right) : super(left, right);
}

class GreaterThan extends BinaryOperator<num, num, bool> {
  @override
  bool value() => left.value() < right.value();
  GreaterThan(left, right) : super(left, right);
}

class And extends BinaryOperator<bool, bool, bool> {
  @override
  bool value() => left.value() && right.value();
  And(left, right) : super(left, right);
}

class Or extends BinaryOperator<bool, bool, bool> {
  @override
  bool value() => left.value() || right.value();
  Or(left, right) : super(left, right);
}
