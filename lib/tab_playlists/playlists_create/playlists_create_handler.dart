import 'dart:io';

import 'package:mockingbird/tab_playlists/playlists_create/playlists_create_events.dart';
import 'package:mockingbird/tab_playlists/playlists_create/playlists_create_state.dart';

class PlaylistsCreateHandler implements PlaylistsCreateEvents {
  const PlaylistsCreateHandler();

  @override
  PlaylistsCreateState playlistsCreateWidgetSelectedCover(
    PlaylistsCreateState state,
    File cover,
  ) {
    return state.copyWith(cover: cover);
  }

  @override
  PlaylistsCreateState playlistsCreateWidgetTypingName(
    PlaylistsCreateState state,
    String name,
  ) {
    if (name.trim().isEmpty) {
      return state.copyWith(creatable: false);
    } else {
      return state.copyWith(creatable: true);
    }
  }
}
