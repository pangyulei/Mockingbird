sealed class AlbumListState {
  const AlbumListState();
}

class AlbumListNull extends AlbumListState {
  const AlbumListNull();
}

class AlbumListData extends AlbumListState {
  final List<int> albumIdList;
  const AlbumListData({required this.albumIdList});

  AlbumListData copyWith({List<int>? albumIdList}) {
    return AlbumListData(albumIdList: albumIdList ?? this.albumIdList);
  }
}
