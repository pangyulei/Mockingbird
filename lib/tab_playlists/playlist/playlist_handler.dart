import 'package:mockingbird/tab_playlists/playlist/playlist_events.dart';
import 'package:mockingbird/tab_playlists/playlist/playlist_state.dart';

class PlaylistHandler implements PlaylistEvents {
  const PlaylistHandler();

  @override
  Stream<PlaylistState> playlistWidgetInitState(int playlistId) async* {
    yield const PlaylistState(showLoading: true);
    //TODO 
  }

}
