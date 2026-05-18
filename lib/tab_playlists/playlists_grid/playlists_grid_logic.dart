import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mockingbird/db/db_playlist.dart';
import 'package:mockingbird/db/objectbox.dart';
import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlists/playlists_grid/playlists_grid_interface_ui_events.dart';
import 'package:mockingbird/tab_playlists/playlists_grid/playlists_grid_state.dart';

import '../../models/track.dart';
import '../../objectbox.g.dart';

class PlaylistsGridLogic implements PlaylistsGridInterfaceUIEvents {
  const PlaylistsGridLogic();

  @override
  Stream<PlaylistsGridState> playlistsGridInitState() async* {
    yield const PlaylistsGridState(showLoading: true);
    final playlists = await DBPlaylist(ObjectBox.instance.store).getAll();
    yield PlaylistsGridState(playlists: playlists, showLoading: false);
  }

  @override
  bool dragTargetWillAccept(
    PlaylistsGridState state,
    Playlist targetPlaylist,
    Playlist draggedPlaylist,
  ) {
    // Don't accept if dragging onto itself
    return draggedPlaylist != targetPlaylist;
  }

  @override
  Stream<PlaylistsGridState> playlistsGridDragTargetAccepted(
    PlaylistsGridState state,
    Playlist targetPlaylist,
    Playlist draggedPlaylist,
  ) async* {
    yield state.copyWith(showLoading: true);
    int fromIndex = state.playlists.indexOf(draggedPlaylist);
    int toIndex = state.playlists.indexOf(targetPlaylist);

    // Create a new list with the reordered items
    final reindexedPlaylists = state.playlists
        .map((p) => p.copyWith())
        .toList();
    //swap db sortorder first, then swap their place in List
    final swappedPlaylists = await DBPlaylist(
      ObjectBox.instance.store,
    ).swapSortOrder(reindexedPlaylists[fromIndex], reindexedPlaylists[toIndex]);
    //dragged id playlist should place at toIndex
    for (final playlist in swappedPlaylists) {
      if (playlist.id == draggedPlaylist.id) {
        reindexedPlaylists.replaceRange(toIndex, toIndex, [playlist]);
      } else if (playlist.id == targetPlaylist.id) {
        reindexedPlaylists.replaceRange(fromIndex, fromIndex, [playlist]);
      } else {
        debugPrint('2 swapped playlists must correspond to drag/target index');
      }
    }
    yield state.copyWith(playlists: reindexedPlaylists, showLoading: false);
  }

  @override
  Stream<PlaylistsGridState> playlistsGridPoppedCreateWidget(
    PlaylistsGridState state,
    ({String name, File? cover})? incompletePlaylist,
  ) async* {
    if (incompletePlaylist == null) {
      yield state;
    } else {
      yield state.copyWith(showLoading: true);
      final newPlaylist = await DBPlaylist(ObjectBox.instance.store).create(
        Playlist(
          name: incompletePlaylist.name,
          sortOrder: state.playlists.length,
          tracks: ToMany<Track>(),
        ),
        incompletePlaylist.cover,
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
    await DBPlaylist(ObjectBox.instance.store).removeMany(playlistsToRemove);

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
