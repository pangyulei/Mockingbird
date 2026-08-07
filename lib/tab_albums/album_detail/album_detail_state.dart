
class AlbumDetailState {
  final String name;
  final List<String> assetIdList;

  const AlbumDetailState({required this.name, required this.assetIdList});

  AlbumDetailState copyWith({String? name, List<String>? assetIdList}) {
    return AlbumDetailState(
      name: name ?? this.name,
      assetIdList: assetIdList ?? this.assetIdList,
    );
  }
}
