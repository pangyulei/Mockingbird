class AlbumDetailState {
  final String name;
  final List<String> mediaIdList;

  const AlbumDetailState({required this.name, required this.mediaIdList});

  AlbumDetailState copyWith({String? name, List<String>? mediaIdList}) {
    return AlbumDetailState(
      name: name ?? this.name,
      mediaIdList: mediaIdList ?? this.mediaIdList,
    );
  }
}
