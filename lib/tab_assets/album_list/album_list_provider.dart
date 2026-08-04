import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_assets/album_list/album_list_state.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../db/entities/en_album.dart';

part 'album_list_provider.g.dart';

@riverpod
class AlbumList extends _$AlbumList {
  @override
  Future<AlbumListState> build() async {
    final albumList = await ref.watch(
      dbAlbumListProvider.future,
    );
    return AlbumListData(AlbumIdList: albumList.map((a) => a.id).toList());
  }
}
