import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_state.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_album_provider.g.dart';

@Riverpod()
class EditAlbum extends _$EditAlbum implements EditAlbumNotifierITF {
  @override
  EditAlbumState build(EnAlbum? album) {
    debugPrint('edit album provider build:\n$album\n');
    ref.onDispose(() {
      debugPrint('edit album provider dispose:\n$album\n');
    });
    if (album == null) {
      return const EditAlbumState.add();
    } else {
      final cover = album.cover;
      return EditAlbumState.edit(
        album.name,
        cover == null ? null : File(cover),
      );
    }
  }

  @override
  Future<void> submit() async {
    EasyLoading.show(maskType: .clear);
    final album = this.album;
    if (album == null) {
      //creating
      await ref
          .read(dbAlbumListProvider.notifier)
          .addAlbum(state.name, cover: state.cover);
    } else {
      //editing
      await ref
          .read(dbAlbumListProvider.notifier)
          .updateAlbum(album, name: state.name, cover: () => state.cover);
    }
    EasyLoading.dismiss();
  }

  @override
  void updateCover(File? newCover) {
    if (newCover?.path != state.cover?.path) {
      final enableSubmit = _isSubmitEnable(state.name, newCover, album);
      state = state.copyWith(cover: () => newCover, enableSubmit: enableSubmit);
    }
  }

  @override
  void updateName(String newName) {
    if (newName != state.name) {
      final enableSubmit = _isSubmitEnable(newName, state.cover, album);
      state = state.copyWith(name: newName, enableSubmit: enableSubmit);
    }
  }

  bool _isSubmitEnable(String name, File? cover, EnAlbum? album) {
    if (name.trim().isEmpty) {
      return false;
    }
    if (album == null) {
      //is creating, only valid name
      return true;
    }
    //is editing, name or cover is different then able to update
    if (name.trim() != album.name) return true;
    if (cover?.path != album.cover) return true;
    return false;
  }
}
