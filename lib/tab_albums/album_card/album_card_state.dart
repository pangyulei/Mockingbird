class AlbumCardState {
  final int mediasCount;
  final String? cover;
  final String name;

  const AlbumCardState({
    required this.mediasCount,
    required this.name,
    required this.cover,
  });

  const AlbumCardState.empty() : this(cover: null, name: '', mediasCount: 0);

  AlbumCardState copyWith({
    int? mediasCount,
    String? Function()? cover,
    String? name,
  }) {
    return AlbumCardState(
      mediasCount: mediasCount ?? this.mediasCount,
      name: name ?? this.name,
      cover: cover == null ? this.cover : cover(),
    );
  }
}
