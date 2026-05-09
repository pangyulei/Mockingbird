
import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_state.dart';

abstract interface class PlaylistsEvents {
  Future<PlaylistsState> playlistsWidgetInitState();
  Stream<PlaylistsState> playlistsWidgetCreatedNewPlaylist(PlaylistsState state);
  PlaylistsState playlistsWidgetAddButtonStateChanged(PlaylistsState state, bool isPressed);
  bool playlistsWidgetDragTargetWillAccept(PlaylistsState state, Playlist targetPlaylist, Playlist draggedPlaylist);
  Future<PlaylistsState?> playlistsWidgetDragTargetAccepted(PlaylistsState state, Playlist targetPlaylist, Playlist draggedPlaylist);
}