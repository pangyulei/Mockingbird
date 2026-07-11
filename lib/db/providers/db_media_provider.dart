import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/entities/en_subtitle.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_media_provider.g.dart';

@Riverpod(name: 'dbMediaProvider')
class DBMedia extends _$DBMedia {
  @override
  Future<EnMedia?> build(int id) async {
    return await DBLogic().loadMedia(id);
  }

  Future<void> delete() async {
    final media = await future;
    if (media == null) {
      debugPrint('media($id)==null');
      return;
    }
    state = await AsyncValue.guard(() async {
      await DBLogic().deleteMedia(media);
      final albumId = media.albums.firstOrNull?.id;
      if (albumId != null) {
        ref
            .read(dbAlbumProvider(albumId).notifier)
            .updateByMediaDeleted(media.id);
      }
      return null;
    });
  }

  Future<void> addSubtitle(EnSubtitle subtitle) async {
    final media = await future;
    if (media == null) {
      debugPrint('no media, can NOT add any subtitle');
      return;
    }
    final albumId = media.albums.firstOrNull?.id;
    if (albumId == null) {
      debugPrint('media didnt releate to album, can NOT add any subtitle');
      return;
    }
    state = await AsyncValue.guard(() async {
      final updatedMedia = await DBLogic().addSubtitle(media, subtitle);
      await ref
          .read(dbAlbumProvider(albumId).notifier)
          .updateByMediaUpdated(updatedMedia);
      return updatedMedia;
    });
  }

  Future<void> deleteSubtitle() async {
    final media = await future;
    if (media == null) {
      debugPrint('media==null, can NOT delete subtitle');
      return;
    }
    final albumId = media.albums.firstOrNull?.id;
    if (albumId == null) {
      debugPrint('media didnt releate to album, can NOT add any subtitle');
      return;
    }
    state = await AsyncValue.guard(() async {
      final updatedMedia = await DBLogic().deleteSubtitle(media);
      await ref
          .read(dbAlbumProvider(albumId).notifier)
          .updateByMediaUpdated(updatedMedia);
      return updatedMedia;
    });
  }

  void updateByAlbumDeleted() {
    state = const AsyncData(null);
  }
}
