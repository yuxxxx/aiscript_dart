import 'dart:convert';
import 'dart:async';

import 'package:aiscript_dart/interpreter/node.dart';
import 'package:aiscript_dart/interpreter/scope.dart';
import 'package:aiscript_dart/interpreter/utils.dart';
import 'dart:io';

import 'package:aiscript_dart/parser/core/node.dart';

mixin class InterpreterOption {
  Future<String> input(String q) {
    print(q);
    return stdin.transform(utf8.decoder).first;
  }

  void output(Value value) => print(value);
  void log(String type, Map<String, dynamic> params) {
    print(
        '$type:${params.entries.map((item) => '${item.key}: ${item.value}').join(', ')}');
  }

  num get maxSteps => double.infinity;
}

class Interpreter {
  final _irqRate = 300;
  get _irqAt => _irqRate - 1;
  final Map<String, VNode> variables;
  final InterpreterOption option;
  var stepCount = 0;
  var stop = false;
  Scope? scope;
  final List<Function> abortHandlers = [];

  Interpreter.initWithDefault() : this({}, InterpreterOption());
  Interpreter(this.variables, this.option) {
    variables.addAll({
      'print': FnNative((args) {
        expectAny(args.first);
        option.output(args.first);
        return Nul();
      }),
      'readline': FnNative((args) {
        final q = args.firstOrNull;
        final question = assertString(q);
        return option.input(question.value).then((value) => Str(value));
      })
    });
    scope = Scope.asRoot(null, variables);
  }

  Future execute(Iterable<Node>? script) async {
    if (script == null || script.isEmpty) return;

    await collectNamespace(script);
    final result = runInternal(script, scope!);

    _log('end', {'val': result});
  }

  void _log(String type, Map<String, dynamic> params) {
    option.log(type, params);
  }

  Future collectNamespace(Iterable<Node> script) async {
    for (var node in script) {
      switch (node) {
        case Namespace ns:
          collectNamespaceMember(ns);
          break;
        default:
          // NOOP
          break;
      }
    }
  }

  Future collectNamespaceMember(Namespace ns) async {
    final scope = this.scope!.createChildScope(null, null);

    for (var node in ns.members) {
      switch (node) {
        case FunctionDefinition def:
          final v = await _eval(def.expression, scope);
          scope.add(node.name, v);
          this.scope!.add('${ns.name}:${node.name}', v);
          break;
      }
    }
  }

  Future<Value> runInternal(Iterable<Node> program, Scope scope) async {
    _log('block:enter', {'scope': scope.name});

    Value v = Nul();

    for (var node in program) {
      v = await _eval(node, scope);
      if (v is VReturn) {
        _log('block:return', {'scope': scope.name, 'val': v.value});
      }
    }

    _log('block:leave', {'scope': scope, 'val': v});
    return v;
  }

  FutureOr<Value> _eval(Node node, Scope scope) async {
    if (stop) return Nul();
    if (stepCount % _irqRate == _irqAt) {
      await Future.delayed(Duration(milliseconds: 5));
    }
    stepCount += 1;

    switch (node) {
      case Literal<String> str:
        return Str(str.value);
    }

    throw Exception('invalid node type: ${node.type}');
  }
}
