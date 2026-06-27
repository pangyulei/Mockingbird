import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_albums/album_edit/ui_album_edit_events.dart';
import 'package:mockingbird/tab_albums/album_edit/ui_album_edit_snapshot.dart';
import 'package:mockingbird/tab_albums/album_edit/ui_album_edit_snapshot_provider_itf.dart';
import 'package:mockingbird/tool/broadcaster.dart';

class UIAlbumEditSnapshotProvider implements UIAlbumEditSnapshotProviderITF {
  @override
  final snapshot = UIAlbumEditSnapshot();
  final ImagePicker _picker = ImagePicker();
  final Album? _album;
  UIAlbumEditSnapshotProvider(this._album) {
    if (_album != null) {
      snapshot.name.value = _album.name;
      snapshot.cover.value = _album.cover != null ? File(_album.cover!) : null;
    }
  }

  @override
  void albumEditNameChanged(String name) {
    snapshot.name.value = name;
    snapshot.enableSubmit.value = name.trim().isNotEmpty;
  }

  @override
  void albumEditOnPickCover() async {
    final XFile? xImage = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    snapshot.cover.value = xImage == null ? null : File(xImage.path);
  }

  @override
  void albumEditOnRemoveCover() {
    snapshot.cover.value = null;
  }

  @override
  void albumEditOnSubmit() {
    Broadcaster().emit<UIAlbumEditEvent>(
      UIAlbumEditEventOnSubmit(
        snapshot.name.value,
        snapshot.cover.value,
        _album,
      ),
    );
    // Navigator.of(context).pop();
  }
}
