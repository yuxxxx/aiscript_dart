import 'package:aiscript_dart/parser/core/accessor.dart';
import 'package:aiscript_dart/parser/core/node.dart';
import 'package:aiscript_dart/parser/plugins/has_chain_prop.dart';
import 'package:aiscript_dart/parser/plugins/is_expression.dart';

Node transformNode(Node node) {
  if (node.isExpression() && node.hasChainProp()) {
    final chain = (node as Chainable).chain;
    var parent = node;
    for (final item in chain) {
      switch (item.type) {
        case 'callChain':
          parent = Call(parent, (item as CallChain).args);
          break;
        case 'indexChain':
          parent = Index(parent, (item as IndexChain).index);
          break;
        case 'propChain':
          parent = Property(parent, (item as PropertyChain).name);
          break;
        default:
          break;
      }
    }
    return parent;
  }
  return node;
}
