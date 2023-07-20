import 'package:aiscript_dart/parser/core/accessor.dart';
import 'package:aiscript_dart/parser/core/node.dart';

Node visitNode(Node node, Function transform) {
  final Node result = transform(node);
  switch (result) {
    case IndexChain res:
      res.index = visitNode(res.index, transform);
      break;
    case CallChain res:
      res.args = res.args.map((e) => visitNode(e, transform));
      break;
    case Property res:
      res.target = visitNode(res.target, transform);
  }

  return result;
}
