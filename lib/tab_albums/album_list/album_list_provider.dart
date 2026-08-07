import 'package:flutter/cupertino.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/db/providers/db_metadata_provider.dart';
import 'package:mockingbird/db/providers/db_preference_provider.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_state.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_list_provider.g.dart';

@riverpod
class AlbumList extends _$AlbumList {
  @override
  Future<AlbumListState> build() async {
    final permissionRequested = await ref.watch(
      dbMetadataProvider.selectAsync((st) => st.permissionRequested),
    );
    if (!permissionRequested) {
      return const AlbumListNotYetRequested();
    }
    //mediaLocation is for media's GPS info, I dont need that.
    //first time state is denied, only allow selected, is limited, allow-all is limited
    final option = PermissionRequestOption(
      androidPermission: AndroidPermission(
        type: RequestType.video | RequestType.audio,
        mediaLocation: false,
      ),
    );
    PermissionState permissionState = await PhotoManager.getPermissionState(
      requestOption: option,
    );
    debugPrint(
      'PhotoManager permission state: $permissionState isAuth:${permissionState.isAuth}',
    );
    if (!permissionState.granted) {
      return const AlbumListPermissionDenied();
    }
    final albumList = await ref.watch(dbAlbumListProvider.future);
    if (albumList.isEmpty) return const AlbumListEmpty();
    return AlbumListData(albumIdList: albumList.map((a) => a.id).toList());
  }

  Future<void> requestPermission() async {
    await PhotoManager.requestPermissionExtend();
    await ref.read(dbMetadataProvider.notifier).setPermissionRequested();
  }
}

extension on PermissionState {
  bool get granted =>
      {PermissionState.limited, PermissionState.authorized}.contains(this);
}
