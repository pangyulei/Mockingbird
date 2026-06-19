import 'dart:io';

import 'package:mockingbird/db/db_album.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import 'package:mockingbird/model/album.dart';
import 'albums_grid_interface_ui_events.dart';
import 'albums_grid_state.dart';


class AlbumsGridLogic implements AlbumsGridInterfaceUIEvents {
  const AlbumsGridLogic();

  @override
  Stream<AlbumsGridState> albumsGridInitState() async* {
    yield const AlbumsGridState(showLoading: true);
    final albums = await DBAlbum(DBObjectBox.instance.store).getAll();
    yield AlbumsGridState(albums: albums, showLoading: false);
  }

  @override
  bool dragTargetWillAccept(
    AlbumsGridState state,
    Album targetAlbum,
    Album draggedAlbum,
  ) {
    // Don't accept if dragging onto itself
    return draggedAlbum != targetAlbum;
  }

  @override
  Stream<AlbumsGridState> albumsGridDragTargetAccepted(
    AlbumsGridState state,
    Album targetAlbum,
    Album draggedAlbum,
  ) async* {
    yield state.copyWith(showLoading: true);
    int fromIndex = state.albums.indexOf(draggedAlbum);
    int toIndex = state.albums.indexOf(targetAlbum);

    // Create a new list with the reordered items
    final reindexedAlbums = state.albums
        .map((p) => p.copyWith())
        .toList();
    //swap db sortorder first, then swap their place in List
    var aAlbum = reindexedAlbums[fromIndex];
    var bAlbum = reindexedAlbums[toIndex];
    (aAlbum, bAlbum) = await DBAlbum(
      DBObjectBox.instance.store,
    ).swapSortOrder(aAlbum, bAlbum);
    reindexedAlbums[fromIndex] = bAlbum;
    reindexedAlbums[toIndex] = aAlbum;
    yield state.copyWith(albums: reindexedAlbums, showLoading: false);
  }

  @override
  Stream<AlbumsGridState> albumsGridPoppedCreateWidget(
    AlbumsGridState state,
    ({String name, File? coverFile})? newAlbumInfo,
  ) async* {
    if (newAlbumInfo == null) {
      yield state;
    } else {
      yield state.copyWith(showLoading: true);
      final newPlaylist = await DBAlbum(DBObjectBox.instance.store).create(
        Album(
          name: newAlbumInfo.name,
          sortOrder: state.albums.length,
        ),
        newAlbumInfo.coverFile,
      );
      if (newPlaylist != null) {
        yield state.copyWith(
          albums: [newPlaylist, ...state.albums],
          showLoading: false,
        );
      } else {
        yield state.copyWith(showLoading: false);
      }
    }
  }

  @override
  AlbumsGridState albumsGridToggleSelectionMode(
    AlbumsGridState state,
  ) {
    // If exiting selection mode, clear selections
    if (state.isSelectionMode) {
      return state.copyWith(isSelectionMode: false, selectedAlbumIds: {});
    }
    return state.copyWith(isSelectionMode: true);
  }

  @override
  AlbumsGridState albumsGridToggleAlbumSelection(
    AlbumsGridState state,
    int albumId,
  ) {
    final Set<int> newSelectedIds = {...state.selectedAlbumIds};
    if (newSelectedIds.contains(albumId)) {
      newSelectedIds.remove(albumId);
    } else {
      newSelectedIds.add(albumId);
    }

    // Auto-exit selection mode if no items are selected
    final bool shouldExitSelectionMode = newSelectedIds.isEmpty;

    return state.copyWith(
      selectedAlbumIds: newSelectedIds,
      isSelectionMode: shouldExitSelectionMode ? false : state.isSelectionMode,
    );
  }

  @override
  Stream<AlbumsGridState> albumsGridBatchRemoveSelected(
    AlbumsGridState state,
  ) async* {
    if (state.selectedAlbumIds.isEmpty) {
      yield state;
      return;
    }

    yield state.copyWith(showLoading: true);

    // Get the playlists to remove
    final playlistsToRemove = state.albums
        .where((p) => state.selectedAlbumIds.contains(p.id))
        .toList();

    // Remove from database
    await DBAlbum(DBObjectBox.instance.store).removeMany(playlistsToRemove);

    // Update state with remaining playlists
    final remainingPlaylists = state.albums
        .where((p) => !state.selectedAlbumIds.contains(p.id))
        .toList();

    yield state.copyWith(
      albums: remainingPlaylists,
      selectedAlbumIds: {},
      isSelectionMode: false,
      showLoading: false,
    );
  }
}
