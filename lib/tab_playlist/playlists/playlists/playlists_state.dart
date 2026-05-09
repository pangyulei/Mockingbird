import 'package:mockingbird/models/playlist.dart';

class PlaylistsState {
  final List<Playlist> playlists;
  final bool isLoadingAll;
  final bool isAddButtonPressed;
  const PlaylistsState({
    this.playlists = const [],
    this.isLoadingAll = true,
    this.isAddButtonPressed = false,
  });

  PlaylistsState copyWith({
    List<Playlist>? playlists,
    bool? showLoading,
    bool? isAddButtonPressed,
  }) {
    return PlaylistsState(
      playlists: playlists != null ? [...playlists] : [...this.playlists],
      isLoadingAll: showLoading ?? isLoadingAll,
      isAddButtonPressed: isAddButtonPressed ?? this.isAddButtonPressed,
    );
  }
}
