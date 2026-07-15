import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_album_provider.g.dart';

@Riverpod(name: 'editAlbumProvider')
class EditAlbum extends _$EditAlbum {
  EnAlbum? _album;

  @override
  Future<EditAlbumState> build(int? id) async {
    debugPrint('EditAlbumNotifier($id) ${identityHashCode(this)} build');
    ref.onDispose(() {
      debugPrint(
        'EditAlbumAsyncNotifier($id) ${identityHashCode(this)} disposed',
      );
    });
    if (id == null) {
      return const EditAlbumState.create();
    } else {
      final album = await ref.watch(dbAlbumProvider(id).future);
      _album = album;
      if (album == null) {
        return const EditAlbumState.empty();
      } else {
        final cover = album.cover;
        return EditAlbumState.edit(
          album.name,
          cover == null ? null : File(cover),
        );
      }
    }
  }

  Future<void> onSubmit() async {
    final data = state.value;
    if (data == null) {
      return;
    }
    state = const AsyncLoading();
    final localId = id;
    if (localId == null) {
      //creating
      await ref
          .read(dbAlbumListProvider.notifier)
          .createAlbum(data.name, cover: data.cover);
    } else {
      //editing
      await ref
          .read(dbAlbumProvider(localId).notifier)
          .updateAlbum(name: data.name, cover: () => data.cover);
    }
  }

  void onCoverChanged(File? newCover) {
    final data = state.value;
    if (data == null) {
      return;
    }
    if (newCover?.path != data.cover?.path) {
      final enableSubmit = _isSubmitEnable(data.name, newCover, _album);
      state = AsyncData(
        data.copyWith(cover: () => newCover, enableSubmit: enableSubmit),
      );
    }
  }

  void onNameChanged(String newName) {
    final data = state.value;
    if (data == null) {
      return;
    }
    if (newName != data.name) {
      final enableSubmit = _isSubmitEnable(newName, data.cover, _album);
      state = AsyncData(
        data.copyWith(name: newName, enableSubmit: enableSubmit),
      );
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
