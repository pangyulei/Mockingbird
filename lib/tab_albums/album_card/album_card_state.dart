class AlbumCardState {
  final int mediaCount;
  final String? cover;
  final String name;
  final bool canSort;

  const AlbumCardState({
    required this.canSort,
    required this.mediaCount,
    required this.name,
    required this.cover,
  });
  const AlbumCardState.empty()
    : this(canSort: false, cover: null, mediaCount: 0, name: '');

  AlbumCardState copyWith({
    int? mediaCount,
    String? Function()? cover,
    String? name,
    bool? canSort,
  }) {
    return AlbumCardState(
      canSort: canSort ?? this.canSort,
      mediaCount: mediaCount ?? this.mediaCount,
      name: name ?? this.name,
      cover: cover == null ? this.cover : cover(),
    );
  }
}
