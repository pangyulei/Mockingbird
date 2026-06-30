import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';

class AlbumsGridState {
  final bool showLoading;
  final int albumsCount;
  final List<AlbumCardState> albumStates;

  const AlbumsGridState({
    required this.showLoading,
    required this.albumStates,
    required this.albumsCount,
  });

  const AlbumsGridState.empty()
    : this(albumStates: const [], albumsCount: 0, showLoading: false);

  AlbumsGridState copyWith({
    bool? showLoading,
    int? albumsCount,
    List<AlbumCardState>? albumStates,
  }) {
    return AlbumsGridState(
      showLoading: showLoading ?? this.showLoading,
      albumStates: albumStates ?? this.albumStates,
      albumsCount: albumsCount ?? this.albumsCount,
    );
  }
}
