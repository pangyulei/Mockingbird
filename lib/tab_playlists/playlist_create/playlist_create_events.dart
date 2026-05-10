import 'dart:io';

import 'package:mockingbird/tab_playlists/playlist_create/playlist_create_state.dart';

abstract interface class PlaylistCreateEvents {
  PlaylistCreateState playlistCreateWidgetSelectedCover(
    PlaylistCreateState state,
    File cover,
  );
  PlaylistCreateState playlistCreateWidgetTypingName(
    PlaylistCreateState state,
    String name,
  );
}
