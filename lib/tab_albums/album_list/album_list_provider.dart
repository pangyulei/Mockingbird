import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/db/providers/db_albums_provider.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_list_provider.g.dart';

@Riverpod(name: 'albumListProvider')
class AlbumList extends _$AlbumList {
  @override
  Future<AlbumListState> build() async {
    final albums = await ref.watch(dbAlbumsProvider.future);
    return AlbumListState(count: albums.length);
  }

  int? albumIdAtIndex(int i) {
    return ref.read(dbAlbumsProvider.notifier).albumAtIndex(i)?.id;
  }

  String? albumNameAtIndex(int i) {
    return ref.read(dbAlbumsProvider.notifier).albumAtIndex(i)?.name;
  }

  Future<void> deleteAlbum(int i) async {
    state = const AsyncLoading();
    final albumId = albumIdAtIndex(i);
    if (albumId != null) {
      await ref.read(dbAlbumProvider(albumId).notifier).delete();
    }
  }
}
