import 'dart:io';

import 'package:mockingbird/db/db_playlist.dart';
import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_events.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_state.dart';

class PlaylistCreateHandler implements PlaylistCreateEvents {
  @override
  Future<Playlist?> playlistCreateWidgetClickedCreate(PlaylistCreateState state, String name) async {
    return await DBPlaylist.createAsync(name, state.cover);
  }

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
