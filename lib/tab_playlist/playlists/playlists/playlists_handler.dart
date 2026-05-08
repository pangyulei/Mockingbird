
import 'package:mockingbird/db/db_playlist.dart';
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
}