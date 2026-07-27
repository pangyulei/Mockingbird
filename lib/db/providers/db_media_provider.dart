import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/entities/en_subtitle.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_media_provider.g.dart';

@Riverpod(name: 'dbMediaProvider')
class DBMedia extends _$DBMedia {
  @override
  Future<EnMedia?> build(int? id) async {
    if (id == null) return null;
    debugPrint('media($id) build');
    ref.onDispose(() => debugPrint('media($id) dispose'));
    return await DBLogic().loadMedia(id);
  }

  Future<void> edit({String? name, EnSubtitle? Function()? subtitle}) async {
    final media = await future;
    if (media == null) return;
    await DBLogic().updateMedia(media, name: name, subtitle: subtitle);
    ref.invalidateSelf();
  }

  Future<void> delete() async {
    final media = await future;
    if (media == null) return;
    await DBLogic().deleteMedia(media);
    ref.invalidateSelf();
    await ref.read(dbPrefProvider.notifier).updateByMediaDeleted([media.id]);
  }
}
