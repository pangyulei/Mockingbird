
import 'package:mockingbird/db/db_playlist.dart';
import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_events.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_state.dart';

class PlaylistsHandler implements PlaylistsEvents {
  @override
  Future<PlaylistsState> playlistsWidgetInitState() async {
    final playlists = await DBPlaylist.all();
    return PlaylistsState(playlists: playlists, isLoadingAll: false);
  }

  @override
  Stream<PlaylistsState> playlistsWidgetCreatedNewPlaylist(PlaylistsState state) async* {
    var newState = state.copyWith(isLoadingAll: true);
    yield newState;
    final playlists = await DBPlaylist.all();
    newState = newState.copyWith(playlists: playlists, isLoadingAll: false);
    yield newState;
  }

  @override
  PlaylistsState playlistsWidgetAddButtonStateChanged(PlaylistsState state, bool isPressed) {
    return state.copyWith(isAddButtonPressed: isPressed);
  }
  
  @override
  bool playlistsWidgetDragTargetWillAccept(PlaylistsState state, Playlist targetPlaylist, Playlist draggedPlaylist) {
    // Don't accept if dragging onto itself
    return draggedPlaylist != targetPlaylist;
  }
  
  @override
  Future<PlaylistsState?> playlistsWidgetDragTargetAccepted(PlaylistsState state, Playlist targetPlaylist, Playlist draggedPlaylist) async {
    int oldIndex = state.playlists.indexOf(draggedPlaylist);
    int newIndex = state.playlists.indexOf(targetPlaylist);

    // Adjust newIndex when moving down (account for the item being removed)
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    // Create a new list with the reordered items
    final List<dynamic> playlists = [...state.playlists];
    final dynamic item = playlists.removeAt(oldIndex);
    playlists.insert(newIndex, item);
    
    // Cast back to List<Playlist>
    final List<Playlist> reorderedPlaylists = List<Playlist>.from(playlists);
    
    // Update the database with new sort orders
    await DBPlaylist.updateSortOrders(reorderedPlaylists);
    
    // Return new state with reordered playlists
    return state.copyWith(playlists: reorderedPlaylists);
  }
}