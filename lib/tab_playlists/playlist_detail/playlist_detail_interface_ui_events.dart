import 'package:mockingbird/tab_playlists/playlist_detail/playlist_detail_state.dart';

abstract interface class PlaylistDetailInterfaceUIEvents {
  Stream<PlaylistDetailState> playlistDetailInitState(int playlistId);

  /// Import audio/video files to the playlist
  Future<PlaylistDetailState> playlistDetailAddTracks(PlaylistDetailState state);
}
