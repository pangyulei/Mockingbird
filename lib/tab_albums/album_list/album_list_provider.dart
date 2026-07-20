import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../db/entities/en_album.dart';

part 'album_list_provider.g.dart';

@riverpod
class AlbumList extends _$AlbumList {
  List<EnAlbum> _albumList = [];

  @override
  AlbumListState build() {
    final List<EnAlbum> albumList = ref.watch(dbAlbumListProvider.select((av) => av.value ?? []));
    _albumList = albumList;
    return AlbumListState(albumCount: albumList.length);
  }

  int? albumIdAtIndex(int i) {
    return _albumList.elementAtOrNull(i)?.id;
  }
}
