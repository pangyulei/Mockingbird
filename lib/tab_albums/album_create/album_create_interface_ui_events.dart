import 'dart:io';

import 'package:mockingbird/tab_albums/album_create/album_create_state.dart';

abstract interface class AlbumCreateInterfaceUIEvents {
  AlbumCreateState albumCreateSelectedCover(
    AlbumCreateState state,
    File coverFile,
  );
  AlbumCreateState albumCreateRemoveCover(
    AlbumCreateState state,
  );
  AlbumCreateState albumCreateTypingName(
    AlbumCreateState state,
    String name,
  );
}
