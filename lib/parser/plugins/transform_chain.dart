import 'package:aiscript_dart/parser/core/accessor.dart';
import 'package:aiscript_dart/parser/core/node.dart';
import 'package:aiscript_dart/parser/plugins/has_chain_prop.dart';
import 'package:aiscript_dart/parser/plugins/is_expression.dart';
import 'package:aiscript_dart/parser/plugins/parser_plugin.dart';
import 'package:aiscript_dart/parser/visit.dart';

Node transformNode(Node node) {
  if (node.isExpression() && node.hasChainProp()) {
    final chain = (node as Chainable).chain;
    var parent = node;
    for (final item in chain) {
      switch (item) {
        case CallChain cc:
          parent = Call(parent, cc.args);
          break;
        case IndexChain ic:
          parent = Index(parent, ic.index);
          break;
        case PropertyChain pc:
          parent = Property(parent, pc.name);
          break;
        default:
          break;
      }
    }
    return parent;
  }
  return node;
}

Iterable<Node> transformChain(Iterable<Node> nodes) {
  List<Node> ret = nodes.toList(growable: false);
  for (var i = 0; i < ret.length; i++) {
    ret[i] = visitNode(ret[i], transformNode);
  }
  return ret;
}

class TransformChain implements ParserPlugin {
  @override
  Iterable<Node> effect(Iterable<Node> nodes) {
    return transformChain(nodes);
  }
}
