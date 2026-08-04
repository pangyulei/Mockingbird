import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_album_list_provider.g.dart';

@Riverpod(name: 'dbAlbumListProvider')
class DBAlbumList extends _$DBAlbumList {
  @override
  Future<List<AssetPathEntity>> build() async {
    PermissionState permissions = await PhotoManager.requestPermissionExtend();
    debugPrint('PhotoManager permission state: $permissions');

    if (!permissions.isAuth) {
      // For Android 13+, permissions.isAuth will be false if the user
      // hasn't granted READ_MEDIA_VIDEO/AUDIO.
      // requestPermissionExtend() handles the dialog, but if it's still false,
      // we might need to guide the user.
      debugPrint('Permission not authorized, state: $permissions');
    }

    final albumList = await PhotoManager.getAssetPathList(
      type: RequestType.audio | RequestType.video,
    );
    debugPrint('albumList: $albumList');
    return albumList;
  }
}
