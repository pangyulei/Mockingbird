import 'package:flutter/cupertino.dart';
import 'package:mockingbird/tab_playlists/playlist_detail/playlist_detail_state.dart';

import '../../models/track.dart';

abstract interface class PlaylistDetailInterfaceUIEvents {
  Stream<PlaylistDetailState> playlistDetailInitState(int playlistId);

  /// Import audio/video files to the playlist
  Stream<PlaylistDetailState> playlistDetailAddTracks(PlaylistDetailState state);

  /// Trigger playing a track
  void playlistDetailPlayTrack(Track track, BuildContext context);
}
