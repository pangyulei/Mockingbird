import 'dart:io';

import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlists/playlists_grid/playlists_grid_state.dart';

abstract interface class PlaylistsGridInterfaceUIEvents {
  Stream<PlaylistsGridState> playlistsGridInitState();
  bool dragTargetWillAccept(
    PlaylistsGridState state,
    Playlist targetPlaylist,
    Playlist draggedPlaylist,
  );
  Stream<PlaylistsGridState> playlistsGridDragTargetAccepted(
    PlaylistsGridState state,
    Playlist targetPlaylist,
    Playlist draggedPlaylist,
  );
  Stream<PlaylistsGridState> playlistsGridPoppedCreateWidget(
    PlaylistsGridState state,
    ({String name, File? cover})? incompletePlaylist,
  );
  PlaylistsGridState playlistsGridToggleSelectionMode(PlaylistsGridState state);
  PlaylistsGridState playlistsGridTogglePlaylistSelection(
    PlaylistsGridState state,
    int playlistId,
  );
  Stream<PlaylistsGridState> playlistsGridBatchRemoveSelected(
    PlaylistsGridState state,
  );
}
