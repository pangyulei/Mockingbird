import 'package:mockingbird/tab_albums/album_card/ui_album_card_snapshot.dart';

import 'ui_albums_grid_snapshot.dart';

abstract interface class UIAlbumsGridSnapshotProviderITF {
  UIAlbumsGridSnapshot get snapshot;
  bool albumsGridAcceptDragAndDrop(
    UIAlbumCardSnapshot drag,
    UIAlbumCardSnapshot drop,
  );
  void albumsGridDragAndDrop(
    UIAlbumCardSnapshot drag,
    UIAlbumCardSnapshot drop,
  );
  void albumsGridInitState();
  void albumsGridDispose();
  void albumsGridOnAddAlbum();
}
