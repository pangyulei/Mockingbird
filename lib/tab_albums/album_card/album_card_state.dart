class AlbumCardState {
  final int index;
  final int mediasCount;
  final String? cover;
  final String name;
  const AlbumCardState({
    required this.index,
    required this.mediasCount,
    required this.name,
    required this.cover,
  });

  AlbumCardState copyWith({
    int? index,
    int? mediasCount,
    String? Function()? cover,
    String? name,
  }) {
    return AlbumCardState(
      index: index ?? this.index,
      mediasCount: mediasCount ?? this.mediasCount,
      name: name ?? this.name,
      cover: cover == null ? this.cover : cover(),
    );
  }
}
