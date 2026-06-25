import 'package:mockingbird/tab_albums/album_edit/ui_album_edit_snapshot.dart';

abstract interface class UIAlbumEditSnapshotProviderITF {
  UIAlbumEditSnapshot get snapshot;
  
  void albumEditNameChanged(String name);
}
