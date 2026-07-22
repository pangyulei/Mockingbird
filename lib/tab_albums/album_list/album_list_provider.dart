import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../db/entities/en_album.dart';

part 'album_list_provider.g.dart';

@riverpod
class AlbumList extends _$AlbumList {
  List<EnAlbum> _albumList = [];

  @override
  Future<AlbumListState> build() async {
    final List<EnAlbum> albumList = await ref.watch(dbAlbumListProvider.future);
    _albumList = albumList;
    if (albumList.isEmpty) return const AlbumListNull();
    return AlbumListData(albumIdList: albumList.map((a)=>a.id).toList());
  }
  
}
