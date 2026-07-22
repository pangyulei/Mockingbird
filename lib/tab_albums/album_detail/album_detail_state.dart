import 'dart:io';

class AlbumDetailState {
  final String name;
  final File? cover;
  final int mediaCount;
  final bool showImport;

  const AlbumDetailState({
    required this.showImport,
    required this.name,
    required this.cover,
    required this.mediaCount,
  });

  const AlbumDetailState.empty()
    : this(cover: null, name: '', mediaCount: 0, showImport: false);

  AlbumDetailState copyWith({
    bool? showImport,
    String? name,
    File? Function()? getCover,
    int? mediaCount,
  }) {
    return AlbumDetailState(
      showImport: showImport ?? this.showImport,
      name: name ?? this.name,
      cover: getCover == null ? cover : getCover(),
      mediaCount: mediaCount ?? this.mediaCount,
    );
  }
}
