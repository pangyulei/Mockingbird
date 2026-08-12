import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_media_provider.g.dart';

@Riverpod(name: 'dbMediaProvider')
class DBMedia extends _$DBMedia {
  @override
  Future<AssetEntity?> build(String? id) async {
    if (id == null) return null;
    return await AssetEntity.fromId(id);
    // final media = await (await ref.watch(
    //   dbAlbumListProvider.selectAsync((al) async {
    //     final mediaListList = await Future.wait(
    //       al
    //           .map(
    //             (a) async => await a.getAssetListRange(
    //               start: 0,
    //               end: await a.assetCountAsync,
    //             ),
    //           )
    //           .toList(),
    //     );
    //     final mediaList = mediaListList.expand((e) => e).toList();
    //     final mediaMap = {for (final a in mediaList) a.id: a};
    //     final media = mediaMap[id];
    //     return media;
    //   }),
    // ));
    // return media;
  }


}
