import 'dart:io';

import 'package:mockingbird/tab_playlists/playlists_create/playlists_create_state.dart';

abstract interface class PlaylistsCreateEvents {
  PlaylistsCreateState playlistsCreateWidgetSelectedCover(
    PlaylistsCreateState state,
    File cover,
  );
  PlaylistsCreateState playlistsCreateWidgetTypingName(
    PlaylistsCreateState state,
    String name,
  );
}
