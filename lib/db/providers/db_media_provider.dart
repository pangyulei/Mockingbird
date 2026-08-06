import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_media_provider.g.dart';

@Riverpod(name: 'dbMediaProvider')
class DBMedia extends _$DBMedia {
  @override
  Future<AssetEntity?> build(String? id) async {
    if (id == null) return null;
    final asset = await (await ref.watch(
      dbAlbumListProvider.selectAsync((al) async {
        final assetListList = await Future.wait(
          al
              .map(
                (a) async => await a.getAssetListRange(
                  start: 0,
                  end: await a.assetCountAsync,
                ),
              )
              .toList(),
        );
        final assetList = assetListList.expand((e) => e).toList();
        final assetMap = {for (final a in assetList) a.id: a};
        final asset = assetMap[id];
        return asset;
      }),
    ));
    return asset;
  }


}
