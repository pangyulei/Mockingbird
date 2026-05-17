import 'package:mockingbird/tab_playlists/playlist/playlist_state.dart';

abstract interface class PlaylistEvents {
  Stream<PlaylistState> playlistWidgetInitState(int playlistId);

  /// Import audio/video files to the playlist
  Future<PlaylistState> playlistWidgetAddTracks(PlaylistState state);
}
