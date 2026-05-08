
import 'package:mockingbird/db/db_playlist.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_events.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_state.dart';

class PlaylistsHandler implements PlaylistsEvents {
  @override
  Future<PlaylistsState> playlistsWidgetInitState() async {
    final playlists = await DBPlaylist.all();
    return PlaylistsState(playlists, isLoadingAll: false);
  }

}