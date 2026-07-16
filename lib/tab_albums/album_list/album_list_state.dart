class AlbumListState {
  final int albumCount;
  const AlbumListState({required this.albumCount});

  AlbumListState copyWith({int? albumCount}) {
    return AlbumListState(albumCount: albumCount ?? this.albumCount);
  }

}
