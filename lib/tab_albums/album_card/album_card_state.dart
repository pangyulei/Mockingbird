class AlbumCardState {
  final int mediasCount;
  final String? cover;
  final String name;
  final bool canSort;
  
  const AlbumCardState({
    required this.canSort,
    required this.mediasCount,
    required this.name,
    required this.cover,
  });

  const AlbumCardState.empty() : this(cover: null, name: '', mediasCount: 0, canSort: false);

  AlbumCardState copyWith({
    int? mediasCount,
    String? Function()? cover,
    String? name,
    bool? canSort,
  }) {
    return AlbumCardState(
      canSort: canSort ?? this.canSort,
      mediasCount: mediasCount ?? this.mediasCount,
      name: name ?? this.name,
      cover: cover == null ? this.cover : cover(),
    );
  }
}
