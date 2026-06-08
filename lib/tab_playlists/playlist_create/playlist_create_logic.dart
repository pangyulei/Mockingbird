import 'dart:io';

import 'package:mockingbird/tab_playlists/playlist_create/playlist_create_interface_ui_events.dart';
import 'package:mockingbird/tab_playlists/playlist_create/playlist_create_state.dart';

class PlaylistCreateLogic implements PlaylistCreateInterfaceUIEvents {
  const PlaylistCreateLogic();

  @override
  PlaylistCreateState playlistCreateSelectedCover(
    PlaylistCreateState state,
    File coverFile,
  ) {
    return state.copyWith(coverFile: coverFile);
  }

  @override
  PlaylistCreateState playlistCreateTypingName(
    PlaylistCreateState state,
    String name,
  ) {
    if (name.trim().isEmpty) {
      return state.copyWith(creatable: false);
    } else {
      return state.copyWith(creatable: true);
    }
  }
}
