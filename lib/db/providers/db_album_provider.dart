import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_album_provider.g.dart';

@Riverpod(name: 'dbAlbumProvider')
class DBFolder extends _$DBFolder {
  @override
  Future<AssetPathEntity?> build(String? id) async {
    if (id == null) return null;
    return await ref.watch(
      dbAlbumListProvider.selectAsync(
        (al) => {for (final a in al) a.id: a}[id],
      ),
    );
  }
}
