import 'dart:io';

class AlbumDetailState {
  final String name;
  final File? cover;
  final List<int> mediaIdList;
  final bool showImport;

  const AlbumDetailState({
    required this.showImport,
    required this.name,
    required this.cover,
    required this.mediaIdList,
  });

  const AlbumDetailState.empty()
    : this(cover: null, name: '', mediaIdList: const [], showImport: false);

  AlbumDetailState copyWith({
    bool? showImport,
    String? name,
    File? Function()? getCover,
    List<int>? mediaIdList,
  }) {
    return AlbumDetailState(
      showImport: showImport ?? this.showImport,
      name: name ?? this.name,
      cover: getCover == null ? cover : getCover(),
      mediaIdList: mediaIdList ?? this.mediaIdList,
    );
  }
}
