import 'package:mockingbird/tab_playlist/playlist/playlist_state.dart';

abstract interface class PlaylistEvents {
  Stream<PlaylistState> playlistWidgetInitState(int playlistId);
}
