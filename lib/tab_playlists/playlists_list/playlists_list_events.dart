import 'dart:io';

import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlists/playlists_list/playlists_list_state.dart';

abstract interface class PlaylistsListEvents {
  Stream<PlaylistsListState> playlistsListWidgetInitState();
  bool playlistsListWidgetDragTargetWillAccept(
    PlaylistsListState state,
    Playlist targetPlaylist,
    Playlist draggedPlaylist,
  );
  Stream<PlaylistsListState> playlistsListWidgetDragTargetAccepted(
    PlaylistsListState state,
    Playlist targetPlaylist,
    Playlist draggedPlaylist,
  );
  Stream<PlaylistsListState> playlistsListWidgetPoppedCreateWidget(
    PlaylistsListState state,
    ({String name, File? cover})? incompletePlaylist,
  );
  PlaylistsListState playlistsListWidgetToggleSelectionMode(
    PlaylistsListState state,
  );
  PlaylistsListState playlistsListWidgetTogglePlaylistSelection(
    PlaylistsListState state,
    int playlistId,
  );
  Stream<PlaylistsListState> playlistsListWidgetBatchRemoveSelected(
    PlaylistsListState state,
  );
}
