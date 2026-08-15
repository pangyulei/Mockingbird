sealed class AlbumListState {
  const AlbumListState();
}

class AlbumListLoadingState extends AlbumListState {
  final AlbumListLoadedState? loaded;
  const AlbumListLoadingState({this.loaded});
}

sealed class AlbumListLoadedState extends AlbumListState {
  const AlbumListLoadedState();
}

class AlbumListNotYetRequestedState extends AlbumListLoadedState {
  const AlbumListNotYetRequestedState();
}

class AlbumListPermissionDeniedState extends AlbumListLoadedState {
  const AlbumListPermissionDeniedState();
}

class AlbumListEmptyState extends AlbumListLoadedState {
  const AlbumListEmptyState();
}

class AlbumListDataState extends AlbumListLoadedState {
  final List<String> albumIdList;

  const AlbumListDataState({required this.albumIdList});
}
