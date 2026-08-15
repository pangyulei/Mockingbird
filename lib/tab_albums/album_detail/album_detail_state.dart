sealed class AlbumDetailState {
  const AlbumDetailState();
}

class AlbumDetailLoadingState extends AlbumDetailState {
  const AlbumDetailLoadingState();
}

sealed class AlbumDetailLoadedState extends AlbumDetailState {
  const AlbumDetailLoadedState();
}

class AlbumDetailNotFoundState extends AlbumDetailLoadedState {
  const AlbumDetailNotFoundState();
}

class AlbumDetailEmptyState extends AlbumDetailLoadedState {
  final String name;
  const AlbumDetailEmptyState(this.name);
}

class AlbumDetailDataState extends AlbumDetailLoadedState {
  final String name;
  final List<String> mediaIdList;

  const AlbumDetailDataState({required this.name, required this.mediaIdList});

}
