sealed class AlbumListState {
  final bool loading;
  const AlbumListState({this.loading = false});
  AlbumListState copyWith({bool? loading});
}

class AlbumListInitState extends AlbumListState {
  const AlbumListInitState() : super(loading: true);

  @override
  AlbumListInitState copyWith({bool? loading}) {
    return this;
  }
}

class AlbumListNotYetRequestedState extends AlbumListState {
  const AlbumListNotYetRequestedState({super.loading});

  @override
  AlbumListNotYetRequestedState copyWith({bool? loading}) {
    return AlbumListNotYetRequestedState(loading: loading ?? this.loading);
  }
}

class AlbumListPermissionDeniedState extends AlbumListState {
  const AlbumListPermissionDeniedState({super.loading});

  @override
  AlbumListPermissionDeniedState copyWith({bool? loading}) {
    return AlbumListPermissionDeniedState(loading: loading ?? this.loading);
  }
}

class AlbumListEmptyState extends AlbumListState {
  const AlbumListEmptyState({super.loading});

  @override
  AlbumListEmptyState copyWith({bool? loading}) {
    return AlbumListEmptyState(loading: loading ?? this.loading);
  }
}

class AlbumListDataState extends AlbumListState {
  final List<String> albumIdList;
  const AlbumListDataState({super.loading, required this.albumIdList});

  @override
  AlbumListDataState copyWith({bool? loading, List<String>? albumIdList}) {
    return AlbumListDataState(
      albumIdList: albumIdList ?? this.albumIdList,
      loading: loading ?? this.loading,
    );
  }
}
