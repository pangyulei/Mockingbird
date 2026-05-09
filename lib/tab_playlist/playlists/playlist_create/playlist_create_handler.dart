import 'dart:io';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_events.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_state.dart';

class PlaylistCreateHandler implements PlaylistCreateEvents {
 
  @override
  PlaylistCreateState playlistCreateWidgetSelectedCover(PlaylistCreateState state, File cover) {
    return state.copyWith(cover: cover);
  }

  @override
  PlaylistCreateState playlistCreateWidgetTypingName(PlaylistCreateState state, String name) {
    if (name.trim().isEmpty) {
      return state.copyWith(creatable: false);
    } else {
      return state.copyWith(creatable: true);
    }
  }
}
