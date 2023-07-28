import 'package:aiscript_dart/interpreter/node.dart';

class ScopeOptions {
  void Function(String type, Map<String, dynamic> params)? log;
  void Function(String name, Value value)? onUpdated;
}

class Scope {
  final String name;
  final Scope? _parent;
  final List<Map<String, VNode>> _layeredStates;
  ScopeOptions options = ScopeOptions();

  Scope(this._layeredStates, this._parent, this.name);
  Scope.allowAnnonymous(
      List<Map<String, VNode>> layer, Scope? parent, String? name)
      : this(layer, parent, name ?? '<annonymous>');
  Scope.withDefault(Scope? parent) : this([], parent, '<annonymous>');
  Scope.asRoot(Scope? parent, Map<String, VNode> state)
      : this([state], parent, '<root>');

  void log(String type, Map<String, dynamic> args) {
    if (_parent == null) {
      _parent!.log(type, args);
    } else {
      if (options.log != null) options.log!(type, args);
    }
  }

  void onUpdated(String type, Value value) {
    if (_parent == null) {
      _parent!.onUpdated(type, value);
    } else {
      if (options.onUpdated != null) options.onUpdated!(type, value);
    }
  }

  Scope createChildScope(Map<String, VNode>? states, String? name) {
    final layer = [states ?? {}, ..._layeredStates];
    return Scope.allowAnnonymous(layer, this, name);
  }
}
