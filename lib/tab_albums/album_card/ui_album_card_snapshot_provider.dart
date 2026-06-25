import 'package:mockingbird/tab_albums/album_card/ui_album_card_snapshot.dart';
import 'package:mockingbird/tab_albums/album_card/ui_album_card_snapshot_provider_itf.dart';

class UIAlbumCardSnapshotProvider implements UIAlbumCardSnapshotProviderITF {
  @override
  UIAlbumCardSnapshot snapshot;
  UIAlbumCardSnapshotProvider(this.snapshot);

  @override
  void albumCardOnTapCancel() {
    snapshot.animatedScale.value = 1;
  }

  @override
  void albumCardOnTapDown() {
    snapshot.animatedScale.value = 0.96;
  }

  @override
  void albumCardOnTapUp() {
    snapshot.animatedScale.value = 1;
  }

}
