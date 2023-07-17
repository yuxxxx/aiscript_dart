import 'package:aiscript_dart/parser/core/node.dart';

extension HasChainPropExtension on Node {
  bool hasChainProp() {
    if (this is Chainable) {
      return (this as Chainable).chain.isNotEmpty;
    }
    return false;
  }
}
