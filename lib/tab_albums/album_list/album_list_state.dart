sealed class AlbumListState {
  const AlbumListState();
}

class AlbumListNotYetRequested extends AlbumListState {
  const AlbumListNotYetRequested();
}

class AlbumListPermissionDenied extends AlbumListState {
  const AlbumListPermissionDenied();
}

class AlbumListEmpty extends AlbumListState {
  const AlbumListEmpty();
}

class AlbumListData extends AlbumListState {
  final List<String> albumIdList;

  const AlbumListData({required this.albumIdList});
}
