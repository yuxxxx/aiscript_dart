import 'package:aiscript_dart/parser/core/node.dart';

abstract class ParserPlugin {
  Iterable<Node> effect(Iterable<Node> nodes);
}
