import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_detail_provider.g.dart';

@riverpod
class AlbumDetail extends _$AlbumDetail {
  @override
  Future<AlbumDetailState?> build(String? id) async {
    final album = await ref.watch(dbAlbumProvider(id).future);
    if (album == null) return null;

    final assetList = await album.getAssetListRange(start: 0, end: await album.assetCountAsync);

    return AlbumDetailState(name: album.name, assetIdList: assetList.map((a) => a.id).toList());
  }
}
