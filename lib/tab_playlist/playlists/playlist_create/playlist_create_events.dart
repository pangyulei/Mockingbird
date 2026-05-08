import 'dart:io';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_state.dart';

abstract interface class PlaylistCreateEvents {
  Future<void> playlistCreateWidgetClickedCreate(PlaylistCreateState state, String name);
  PlaylistCreateState playlistCreateWidgetSelectedCover(PlaylistCreateState state, File cover);
  PlaylistCreateState playlistCreateWidgetTypingName(PlaylistCreateState state, String name);
}
