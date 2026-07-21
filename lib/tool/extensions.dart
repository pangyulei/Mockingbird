extension IterableExtension<E> on Iterable<E> {
  int? firstIndexWhereOrNull(bool Function(E) test) {
    int i = 0;
    for (final element in this) {
      if (test(element)) {
        return i;
      }
      i++;
    }
    return null;
  }
}
