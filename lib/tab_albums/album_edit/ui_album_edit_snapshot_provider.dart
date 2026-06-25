import 'package:mockingbird/tab_albums/album_edit/ui_album_edit_snapshot.dart';
import 'package:mockingbird/tab_albums/album_edit/ui_album_edit_snapshot_provider_itf.dart';

class UIAlbumEditSnapshotProvider implements UIAlbumEditSnapshotProviderITF {
  @override
  final snapshot = UIAlbumEditSnapshot();

  @override
  void albumEditNameChanged(String name) {
    snapshot.name.value = name;
    snapshot.enableSubmit.value = name.trim().isNotEmpty;
  }
}
