import 'dart:io';

class AlbumState {
  final String name;
  final File? cover;
  final int mediaCount;

  const AlbumState({
    required this.name,
    required this.cover,
    required this.mediaCount,
  });

  const AlbumState.empty() : this(cover: null, name: '', mediaCount: 0);

  AlbumState copyWith({
    bool? showImport,
    String? name,
    File? Function()? cover,
    int? mediaCount,
  }) {
    return AlbumState(
      name: name ?? this.name,
      cover: cover == null ? this.cover : cover(),
      mediaCount: mediaCount ?? this.mediaCount,
    );
  }
}
