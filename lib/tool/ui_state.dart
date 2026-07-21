class UIState<D> {
  final bool isLoading;
  final D data;

  const UIState({required this.data, this.isLoading = false});
  UIState<D> copyWith({bool? isLoading, D? data}) {
    return UIState<D>(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
    );
  }
}

class UIStateNullable<D> {
  final bool isLoading;
  final D? data;

  const UIStateNullable({this.isLoading = false, this.data});
  UIStateNullable<D> copyWith({bool? isLoading, D? Function()? data}) {
    return UIStateNullable<D>(
      isLoading: isLoading ?? this.isLoading,
      data: data == null ? null : data(),
    );
  }
}
