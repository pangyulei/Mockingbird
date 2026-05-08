

import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_state.dart';

abstract interface class PlaylistsEvents {
  Future<PlaylistsState> playlistsWidgetInitState();
  Stream<PlaylistsState> playlistsWidgetCreatedNewPlaylist(PlaylistsState state);
  PlaylistsState playlistsWidgetAddButtonStateChanged(PlaylistsState state, bool isPressed);
}