import 'dart:io';

import 'package:mockingbird/db/db.dart';
import 'package:mockingbird/db/db_playlist.dart';
import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_events.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_state.dart';

class PlaylistsHandler implements PlaylistsEvents {
  @override
  Future<PlaylistsState> playlistsWidgetInitState() async {
    final playlists = await DBPlaylist(DB.instance.store).getAllAsync();
    return PlaylistsState(playlists: playlists, isLoadingAll: false);
  }

  @override
  bool playlistsWidgetDragTargetWillAccept(
    PlaylistsState state,
    Playlist targetPlaylist,
    Playlist draggedPlaylist,
  ) {
    // Don't accept if dragging onto itself
    return draggedPlaylist != targetPlaylist;
  }

  @override
  Stream<PlaylistsState> playlistsWidgetDragTargetAccepted(
    PlaylistsState state,
    Playlist targetPlaylist,
    Playlist draggedPlaylist,
  ) async* {
    yield state.copyWith(showLoading: true);
    int oldIndex = state.playlists.indexOf(draggedPlaylist);
    int newIndex = state.playlists.indexOf(targetPlaylist);

    // Create a new list with the reordered items
    final List<Playlist> reindexedPlaylists = [...state.playlists];
    final Playlist movedPlaylist = reindexedPlaylists.removeAt(oldIndex);
    reindexedPlaylists.insert(newIndex, movedPlaylist);

    // Update the database with new sort orders
    final updatedPlaylists = await DBPlaylist(
      DB.instance.store,
    ).updateSortOrdersAsync(reindexedPlaylists);

    // Return new state with reordered playlists
    yield state.copyWith(playlists: updatedPlaylists, showLoading: false);
  }

  @override
  Stream<PlaylistsState> playlistsWidgetPoppedCreateWidget(
    PlaylistsState state,
    ({String name, File? cover})? incompletePlaylist,
  ) async* {
    if (incompletePlaylist == null) {
      yield state;
    } else {
      yield state.copyWith(showLoading: true);
      final newPlaylist = await DBPlaylist(DB.instance.store).createAsync(
        Playlist(incompletePlaylist.name, state.playlists.length),
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
  PlaylistsState playlistsWidgetToggleSelectionMode(PlaylistsState state) {
    // If exiting selection mode, clear selections
    if (state.isSelectionMode) {
      return state.copyWith(
        isSelectionMode: false,
        selectedPlaylistIds: {},
      );
    }
    return state.copyWith(isSelectionMode: true);
  }

  @override
  PlaylistsState playlistsWidgetTogglePlaylistSelection(
    PlaylistsState state,
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
  Stream<PlaylistsState> playlistsWidgetBatchRemoveSelected(
    PlaylistsState state,
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
    await DBPlaylist(DB.instance.store).removeManyAsync(playlistsToRemove);

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
