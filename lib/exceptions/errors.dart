class SyntaxError extends Error {
  String get message => _message;
  final String _message;

  SyntaxError(this._message);
  @override
  String toString() {
    return super.toString() + message;
  }
}

class RuntimeError extends Error {
  String get message => _message;
  final String _message;

  RuntimeError(this._message);
  @override
  String toString() {
    return super.toString() + message;
  }
}
