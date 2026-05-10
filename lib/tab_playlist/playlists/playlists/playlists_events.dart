import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_state.dart';
import 'dart:io';

abstract interface class PlaylistsEvents {
  Future<PlaylistsState> playlistsWidgetInitState();
  bool playlistsWidgetDragTargetWillAccept(
    PlaylistsState state,
    Playlist targetPlaylist,
    Playlist draggedPlaylist,
  );
  Stream<PlaylistsState> playlistsWidgetDragTargetAccepted(
    PlaylistsState state,
    Playlist targetPlaylist,
    Playlist draggedPlaylist,
  );
  Stream<PlaylistsState> playlistsWidgetPoppedCreateWidget(
    PlaylistsState state,
    ({String name, File? cover})? incompletePlaylist,
  );
  PlaylistsState playlistsWidgetToggleSelectionMode(PlaylistsState state);
  PlaylistsState playlistsWidgetTogglePlaylistSelection(
    PlaylistsState state,
    int playlistId,
  );
  Stream<PlaylistsState> playlistsWidgetBatchRemoveSelected(
    PlaylistsState state,
  );
}
