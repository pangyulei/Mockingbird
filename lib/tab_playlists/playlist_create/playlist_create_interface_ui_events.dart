import 'dart:io';

import 'package:mockingbird/tab_playlists/playlist_create/playlist_create_state.dart';

abstract interface class PlaylistCreateInterfaceUIEvents {
  PlaylistCreateState playlistCreateSelectedCover(
    PlaylistCreateState state,
    File coverFile,
  );
  PlaylistCreateState playlistCreateTypingName(
    PlaylistCreateState state,
    String name,
  );
}
