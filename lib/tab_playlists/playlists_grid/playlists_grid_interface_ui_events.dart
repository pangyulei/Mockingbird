import 'dart:io';

import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_playlists/playlists_grid/playlists_grid_state.dart';

abstract interface class PlaylistsGridInterfaceUIEvents {
  Stream<PlaylistsGridState> playlistsGridInitState();
  bool dragTargetWillAccept(
    PlaylistsGridState state,
    Album targetPlaylist,
    Album draggedPlaylist,
  );
  Stream<PlaylistsGridState> playlistsGridDragTargetAccepted(
    PlaylistsGridState state,
    Album targetPlaylist,
    Album draggedPlaylist,
  );
  Stream<PlaylistsGridState> playlistsGridPoppedCreateWidget(
    PlaylistsGridState state,
    ({String name, File? coverFile})? newPlaylistInfo,
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
