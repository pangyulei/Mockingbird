class AlbumListState {
  final int albumCount;
  const AlbumListState({required this.albumCount});

  AlbumListState copyWith({int? count}) {
    return AlbumListState(albumCount: count ?? this.albumCount);
  }
}
