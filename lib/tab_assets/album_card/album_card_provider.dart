import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/tab_assets/album_card/album_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_card_provider.g.dart';

@riverpod
class AlbumCard extends _$AlbumCard {
  @override
  Future<AlbumCardState?> build(String id) async {
    final album = await ref.watch(dbAlbumProvider(id).future);
    if (album == null) return null;
    // AssetPathEntity has assetCountAsync
    final count = await album.assetCountAsync;
    return AlbumCardState(mediaCount: count, name: album.name);
  }

}
