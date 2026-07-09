import 'package:flutter/foundation.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/album.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synchronized/synchronized.dart';

part 'db_album_provider.g.dart';

@Riverpod(name: 'dbAlbumAsyncProvider')
class DBAlbumAsync extends _$DBAlbumAsync {
  final _lock = Lock();

  @override
  FutureOr<Album?> build(int id) async {
    ref.onDispose(() {
      debugPrint('DBAlbumAsyncNotifier ${identityHashCode(this)} disposed');
    });
    return await DBLogic().loadAlbum(id);
  }
}
