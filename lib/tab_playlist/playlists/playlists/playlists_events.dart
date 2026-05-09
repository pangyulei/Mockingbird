import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_state.dart';
import 'dart:io';

abstract interface class PlaylistsEvents {
  Future<PlaylistsState> playlistsWidgetInitState();
  PlaylistsState playlistsWidgetAddButtonStateChanged(
    PlaylistsState state,
    bool isPressed,
  );
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
}
