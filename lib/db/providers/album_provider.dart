import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/album.dart';
import 'package:synchronized/synchronized.dart';

class AlbumNotifier extends AsyncNotifier<Album?> {
  final int _id;
  final _lock = Lock();
  AlbumNotifier(this._id);

  @override
  Future<Album?> build() async {
    ref.onDispose(() {
      debugPrint('AlbumNotifier ${identityHashCode(this)} disposed');
    });
    return await DBLogic().loadAlbum(_id);
  }
}

final albumProvider = AsyncNotifierProvider.autoDispose
    .family<AlbumNotifier, Album?, int>(AlbumNotifier.new);
