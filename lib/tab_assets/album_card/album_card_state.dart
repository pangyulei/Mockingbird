class AlbumCardState {
  final int mediaCount;
  final String name;

  const AlbumCardState({required this.mediaCount, required this.name});
  const AlbumCardState.empty() : this(mediaCount: 0, name: '');

  AlbumCardState copyWith({int? mediaCount, String? name}) {
    return AlbumCardState(
      mediaCount: mediaCount ?? this.mediaCount,
      name: name ?? this.name,
    );
  }
}
