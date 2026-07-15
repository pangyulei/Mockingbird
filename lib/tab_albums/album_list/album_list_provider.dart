import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_list_provider.g.dart';

@Riverpod(name: 'albumListProvider')
class AlbumList extends _$AlbumList {
  @override
  Future<AlbumListState> build() async {
    final albums = await ref.watch(dbAlbumListProvider.future);
    return AlbumListState(albumCount: albums.length);
  }

  int? albumIdAtIndex(int i) {
    return ref.read(dbAlbumListProvider.notifier).albumAtIndex(i)?.id;
  }


}
