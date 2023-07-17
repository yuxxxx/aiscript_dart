extension ItemsEqualsExtension<T> on Iterable<T> {
  bool everyEquals(Iterable<T> other) {
    return indexed
        .every((element) => element.$2 == other.elementAt(element.$1));
  }
}
