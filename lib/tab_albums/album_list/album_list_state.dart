sealed class AlbumListState {
  const AlbumListState();
}

class AlbumListInitState extends AlbumListState {
  const AlbumListInitState();
}

class AlbumListNotYetRequestedState extends AlbumListState {
  const AlbumListNotYetRequestedState();
}

class AlbumListPermissionDeniedState extends AlbumListState {
  const AlbumListPermissionDeniedState();
}

class AlbumListEmptyState extends AlbumListState {
  const AlbumListEmptyState();
}

class AlbumListDataState extends AlbumListState {
  final List<String> albumIdList;
  const AlbumListDataState(this.albumIdList);

  AlbumListDataState copyWith({List<String>? albumIdList}) {
    return AlbumListDataState(albumIdList ?? this.albumIdList);
  }
}
