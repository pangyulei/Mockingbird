import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_list_provider.g.dart';

@Riverpod(name: 'albumListProvider')
class AlbumList extends _$AlbumList {
  @override
  Future<AlbumListState> build() async {
    EasyLoading.show(maskType: .clear);
    final albumCount = await ref.watch(dbAlbumListProvider.selectAsync((s) => s.length));
    EasyLoading.dismiss();
    return AlbumListState(albumCount: albumCount);
  }

  int? albumIdAtIndex(int i) {
    final albums = ref.read(dbAlbumListProvider).value ?? [];
    return albums.elementAtOrNull(i)?.id;
  }
}
