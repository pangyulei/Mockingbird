import 'dart:io';

import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tool/broadcaster.dart';

sealed class UIAlbumEditEvent extends BroadcastEvent {
  const UIAlbumEditEvent();
}

class UIAlbumEditEventOnSubmit extends UIAlbumEditEvent {
  final String name;
  final File? cover;
  final Album? album;
  const UIAlbumEditEventOnSubmit(this.name, this.cover, this.album);
}

class UIAlbumEditEventOnCancel extends UIAlbumEditEvent {
  const UIAlbumEditEventOnCancel();
}
