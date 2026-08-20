sealed class AlbumDetailState {
  final bool loading;
  const AlbumDetailState({this.loading = false});
  AlbumDetailState copyWith({bool? loading});
}

class AlbumDetailInitState extends AlbumDetailState {
  const AlbumDetailInitState() : super(loading: true);

  @override
  AlbumDetailInitState copyWith({bool? loading}) {
    return this;
  }
}

class AlbumDetailNotFoundState extends AlbumDetailState {
  const AlbumDetailNotFoundState({super.loading});

  @override
  AlbumDetailNotFoundState copyWith({bool? loading}) {
    return AlbumDetailNotFoundState(loading: loading ?? this.loading);
  }
}

class AlbumDetailEmptyState extends AlbumDetailState {
  final String name;
  const AlbumDetailEmptyState({super.loading, required this.name});
  @override
  AlbumDetailEmptyState copyWith({bool? loading, String? name}) {
    return AlbumDetailEmptyState(
      loading: loading ?? this.loading,
      name: name ?? this.name,
    );
  }
}

class AlbumDetailDataState extends AlbumDetailState {
  final String name;
  final List<String> mediaIdList;

  const AlbumDetailDataState({
    super.loading,
    required this.name,
    required this.mediaIdList,
  });
  @override
  AlbumDetailDataState copyWith({
    bool? loading,
    String? name,
    List<String>? mediaIdList,
  }) {
    return AlbumDetailDataState(
      loading: loading ?? this.loading,
      name: name ?? this.name,
      mediaIdList: mediaIdList ?? this.mediaIdList,
    );
  }
}
