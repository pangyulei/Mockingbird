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
  Stream<PlaylistsState> playlistsWidgetCreatedNewPlaylist(
    PlaylistsState state,
  ) async* {
    yield state.copyWith(showLoading: true);
    final playlists = await DBPlaylist(DB.instance.store).getAllAsync();
    yield state.copyWith(playlists: playlists, showLoading: false);;
  }

  @override
  PlaylistsState playlistsWidgetAddButtonStateChanged(
    PlaylistsState state,
    bool isPressed,
  ) {
    return state.copyWith(isAddButtonPressed: isPressed);
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
    final List<Playlist> repositionedPlaylists = [...state.playlists];
    final Playlist movedPlaylist = repositionedPlaylists.removeAt(oldIndex);
    repositionedPlaylists.insert(newIndex, movedPlaylist);

    // Update the database with new sort orders
    final updatedPlaylists = await DBPlaylist(DB.instance.store).updateSortOrdersAsync(
      repositionedPlaylists,
    );

    // Return new state with reordered playlists
    yield state.copyWith(playlists: updatedPlaylists, showLoading: false);
  }
}
