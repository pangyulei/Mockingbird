import 'package:flutter/material.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_albums/album_card/ui_album_card_snapshot.dart';

class UIAlbumsGridSnapshot {
  final showLoading = ValueNotifier<bool>(false);
  final showEditingAlbumDialog = ValueNotifier<Album?>(null);
  final showCreatingAlbumDialog = ValueNotifier<bool>(false);
  final albumCardSnapshots = ValueNotifier<List<UIAlbumCardSnapshot>>([]);

  void dispose() {
    showCreatingAlbumDialog.dispose();
    showLoading.dispose();
    albumCardSnapshots.dispose();
    showEditingAlbumDialog.dispose();
  }
}
