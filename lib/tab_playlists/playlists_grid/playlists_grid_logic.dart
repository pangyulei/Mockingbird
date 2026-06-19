import 'dart:io';

import 'package:mockingbird/db/db_album.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_playlists/playlists_grid/playlists_grid_interface_ui_events.dart';
import 'package:mockingbird/tab_playlists/playlists_grid/playlists_grid_state.dart';


class PlaylistsGridLogic implements PlaylistsGridInterfaceUIEvents {
  const PlaylistsGridLogic();

  @override
  Stream<PlaylistsGridState> playlistsGridInitState() async* {
    yield const PlaylistsGridState(showLoading: true);
    final playlists = await DBAlbum(DBObjectBox.instance.store).getAll();
    yield PlaylistsGridState(playlists: playlists, showLoading: false);
  }

  @override
  bool dragTargetWillAccept(
    PlaylistsGridState state,
    Album targetPlaylist,
    Album draggedPlaylist,
  ) {
    // Don't accept if dragging onto itself
    return draggedPlaylist != targetPlaylist;
  }

  @override
  Stream<PlaylistsGridState> playlistsGridDragTargetAccepted(
    PlaylistsGridState state,
    Album targetPlaylist,
    Album draggedPlaylist,
  ) async* {
    yield state.copyWith(showLoading: true);
    int fromIndex = state.playlists.indexOf(draggedPlaylist);
    int toIndex = state.playlists.indexOf(targetPlaylist);

    // Create a new list with the reordered items
    final reindexedPlaylists = state.playlists
        .map((p) => p.copyWith())
        .toList();
    //swap db sortorder first, then swap their place in List
    var aPlaylist = reindexedPlaylists[fromIndex];
    var bPlaylist = reindexedPlaylists[toIndex];
    (aPlaylist, bPlaylist) = await DBAlbum(
      DBObjectBox.instance.store,
    ).swapSortOrder(aPlaylist, bPlaylist);
    reindexedPlaylists[fromIndex] = bPlaylist;
    reindexedPlaylists[toIndex] = aPlaylist;
    yield state.copyWith(playlists: reindexedPlaylists, showLoading: false);
  }

  @override
  Stream<PlaylistsGridState> playlistsGridPoppedCreateWidget(
    PlaylistsGridState state,
    ({String name, File? coverFile})? newPlaylistInfo,
  ) async* {
    if (newPlaylistInfo == null) {
      yield state;
    } else {
      yield state.copyWith(showLoading: true);
      final newPlaylist = await DBAlbum(DBObjectBox.instance.store).create(
        Album(
          name: newPlaylistInfo.name,
          sortOrder: state.playlists.length,
        ),
        newPlaylistInfo.coverFile,
      );
      if (newPlaylist != null) {
        yield state.copyWith(
          playlists: [newPlaylist, ...state.playlists],
          showLoading: false,
        );
      } else {
        yield state.copyWith(showLoading: false);
      }
    }
  }

  @override
  PlaylistsGridState playlistsGridToggleSelectionMode(
    PlaylistsGridState state,
  ) {
    // If exiting selection mode, clear selections
    if (state.isSelectionMode) {
      return state.copyWith(isSelectionMode: false, selectedPlaylistIds: {});
    }
    return state.copyWith(isSelectionMode: true);
  }

  @override
  PlaylistsGridState playlistsGridTogglePlaylistSelection(
    PlaylistsGridState state,
    int playlistId,
  ) {
    final Set<int> newSelectedIds = {...state.selectedPlaylistIds};
    if (newSelectedIds.contains(playlistId)) {
      newSelectedIds.remove(playlistId);
    } else {
      newSelectedIds.add(playlistId);
    }

    // Auto-exit selection mode if no items are selected
    final bool shouldExitSelectionMode = newSelectedIds.isEmpty;

    return state.copyWith(
      selectedPlaylistIds: newSelectedIds,
      isSelectionMode: shouldExitSelectionMode ? false : state.isSelectionMode,
    );
  }

  @override
  Stream<PlaylistsGridState> playlistsGridBatchRemoveSelected(
    PlaylistsGridState state,
  ) async* {
    if (state.selectedPlaylistIds.isEmpty) {
      yield state;
      return;
    }

    yield state.copyWith(showLoading: true);

    // Get the playlists to remove
    final playlistsToRemove = state.playlists
        .where((p) => state.selectedPlaylistIds.contains(p.id))
        .toList();

    // Remove from database
    await DBAlbum(DBObjectBox.instance.store).removeMany(playlistsToRemove);

    // Update state with remaining playlists
    final remainingPlaylists = state.playlists
        .where((p) => !state.selectedPlaylistIds.contains(p.id))
        .toList();

    yield state.copyWith(
      playlists: remainingPlaylists,
      selectedPlaylistIds: {},
      isSelectionMode: false,
      showLoading: false,
    );
  }
}
