sealed class AlbumListState {
  const AlbumListState();
}

class AlbumListNull extends AlbumListState {
  const AlbumListNull();
}

class AlbumListData extends AlbumListState {
  final List<String> AlbumIdList;
  const AlbumListData({required this.AlbumIdList});

  AlbumListData copyWith({List<String>? folderIdList}) {
    return AlbumListData(AlbumIdList: folderIdList ?? this.AlbumIdList);
  }
}
