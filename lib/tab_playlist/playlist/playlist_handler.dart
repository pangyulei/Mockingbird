import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlist/playlist/playlist_events.dart';
import 'package:mockingbird/tab_playlist/playlist/playlist_state.dart';

class PlaylistHandler implements PlaylistEvents {

  @override
  Stream<PlaylistState> playlistWidgetInitState(int playlistId) async* {
    yield const PlaylistState(showLoading: true);
    //TODO
    here
  }

}
