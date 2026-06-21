import 'dart:io';

import 'package:mockingbird/tab_albums/album_create/album_create_interface_ui_events.dart';
import 'package:mockingbird/tab_albums/album_create/album_create_state.dart';

class AlbumCreateLogic implements AlbumCreateInterfaceUIEvents {
  const AlbumCreateLogic();

  @override
  AlbumCreateState albumCreateSelectedCover(
    AlbumCreateState state,
    File coverFile,
  ) {
    return state.copyWith(coverFile: () => coverFile);
  }

  @override
  AlbumCreateState albumCreateRemoveCover(
    AlbumCreateState state,
  ) {
    return state.copyWith(coverFile: () => null);
  }

  @override
  AlbumCreateState albumCreateTypingName(
    AlbumCreateState state,
    String name,
  ) {
    if (name.trim().isEmpty) {
      return state.copyWith(creatable: false);
    } else {
      return state.copyWith(creatable: true);
    }
  }
}
