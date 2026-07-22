sealed class AlbumListState {
  const AlbumListState();
}

class AlbumListNull extends AlbumListState {
  const AlbumListNull();
}

class AlbumListData extends AlbumListState {
  final int albumCount;
  const AlbumListData({required this.albumCount});

  AlbumListData copyWith({int? albumCount}) {
    return AlbumListData(albumCount: albumCount ?? this.albumCount);
  }
}
