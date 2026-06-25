import 'ui_album_card_snapshot.dart';

abstract interface class UIAlbumCardSnapshotProviderITF {
  UIAlbumCardSnapshot get snapshot;
  void albumCardOnTapDown();
  void albumCardOnTapUp();
  void albumCardOnTapCancel();
}
