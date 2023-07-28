import 'package:aiscript_dart/aiscript.dart';
import 'package:aiscript_dart/parser/core/node.dart';
import 'package:aiscript_dart/parser/plugins/parser_plugin.dart';

class Parser {
  static final Parser _parser = Parser();

  static Iterable<Node> parseInput(String input) {
    return _parser.parse(input);
  }

  final plugins = {
    'transformers': List<ParserPlugin>.empty(),
    'validators': List<ParserPlugin>.empty()
  };

  Iterable<Node> parse(String input) {
    try {
      final nodes = parseMain(input);
      final validated = plugins['validators']
              ?.fold(nodes, (res, validator) => validator.effect(res)) ??
          [];
      final transformed = plugins['transformers']
              ?.fold(validated, (res, validator) => validator.effect(res)) ??
          [];
      return transformed;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
