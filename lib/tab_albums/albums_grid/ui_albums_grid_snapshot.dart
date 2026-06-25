import 'package:flutter/material.dart';
import 'package:mockingbird/tab_albums/album_card/ui_album_card_snapshot.dart';

class UIAlbumsGridSnapshot {
  final showLoading = ValueNotifier<bool>(false);
  final showUIAlbumEdit = ValueNotifier<bool>(false);
  final albumCardSnapshots = ValueNotifier<List<UIAlbumCardSnapshot>>([]);

  void dispose() {
    showLoading.dispose();
    albumCardSnapshots.dispose();
    showUIAlbumEdit.dispose();
  }
}
