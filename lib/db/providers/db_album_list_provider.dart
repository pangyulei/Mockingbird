import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_album_list_provider.g.dart';

@Riverpod(name: 'dbAlbumListProvider')
class DBAlbumList extends _$DBAlbumList {
  @override
  Future<List<AssetPathEntity>> build() async {
    final albumList = await PhotoManager.getAssetPathList(
      type: RequestType.audio | RequestType.video,
    );
    return albumList;
  }
}
