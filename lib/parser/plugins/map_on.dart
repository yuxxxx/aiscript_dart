import 'package:petitparser/petitparser.dart';

typedef CallBackWithPosition<T, R> = R Function(T value, int position);

extension MapParserExtension<R> on Parser<R> {
  Parser<S> mapOn<S>(CallBackWithPosition<R, S> callback) =>
      MapOnParser<R, S>(this, callback);
}

class MapOnParser<R, S> extends DelegateParser<R, S> {
  MapOnParser(super.delegate, this.callback);

  /// The production action to be called.
  final CallBackWithPosition<R, S> callback;

  @override
  Result<S> parseOn(Context context) {
    final result = delegate.parseOn(context);
    if (result.isSuccess) {
      return result.success(callback(result.value, result.position));
    } else {
      return result.failure(result.message);
    }
  }

  @override
  bool hasEqualProperties(MapOnParser<R, S> other) =>
      super.hasEqualProperties(other) && callback == other.callback;

  @override
  MapOnParser<R, S> copy() => MapOnParser<R, S>(delegate, callback);
}
