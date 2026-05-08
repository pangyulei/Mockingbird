

import 'package:mockingbird/models/playlist.dart';

class PlaylistsState {
  final List<Playlist> playlists;
  final bool isLoadingAll;
  const PlaylistsState({this.playlists = const [], this.isLoadingAll = true});

  PlaylistsState copyWith({
    List<Playlist>? playlists,
    bool? isLoadingAll,
  }) {
    return PlaylistsState(
      playlists: playlists != null ? [...playlists] : [...this.playlists],
      isLoadingAll: isLoadingAll ?? this.isLoadingAll,
    );
  }
}