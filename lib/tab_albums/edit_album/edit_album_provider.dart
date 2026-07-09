import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:mockingbird/db/entities/album.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/db/providers/db_albums_provider.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_album_provider.g.dart';

@riverpod
class EditAlbumAsync extends _$EditAlbumAsync {
  Album? _album;

  @override
  Future<Album?> build(int? id) async {
    ref.onDispose(() {
      debugPrint('EditAlbumAsyncNotifier ${identityHashCode(this)} disposed');
    });
    if (id == null) {
      return null;
    } else {
      _album = ref.watch(dbAlbumAsyncProvider(id)).value;
      return _album;
    }
  }

  Future<void> onSubmit() async {
    state = const AsyncLoading();
    final album = _album;
    if (album == null) {
      //creating
      await AsyncValue.guard(() async {
        final data = ref.read(editAlbumProvider(id));
        await ref
            .read(dbAlbumsAsyncProvider.notifier)
            .createAlbum(data.name, cover: data.cover);
      });
    } else {
      //editing
      state = await AsyncValue.guard(() async {
        final data = ref.read(editAlbumProvider(id));
        _album = await ref
            .read(dbAlbumsAsyncProvider.notifier)
            .updateAlbum(album, name: data.name, cover: () => data.cover);
        return _album;
      });
    }
  }
}

@riverpod
class EditAlbum extends _$EditAlbum {
  @override
  EditAlbumState build(int? id) {
    if (id == null) {
      return const EditAlbumState.empty();
    } else {
      final album = ref.watch(dbAlbumAsyncProvider(id)).value;
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

  void onCoverChanged(File? newCover) {
    if (newCover?.path != state.cover?.path) {
      final album = _$args == null ? null : ref.watch(dbAlbumAsyncProvider(_$args)).value;
      final enableSubmit = _isSubmitEnable(state.name, newCover, album);
      state = state.copyWith(cover: () => newCover, enableSubmit: enableSubmit);
    }
  }

  void onNameChanged(String newName) {
    if (newName != state.name) {
      final album = _$args == null ? null : ref.watch(dbAlbumAsyncProvider(_$args)).value;
      final enableSubmit = _isSubmitEnable(newName, state.cover, album);
      state = state.copyWith(name: newName, enableSubmit: enableSubmit);
    }
  }

  bool _isSubmitEnable(String name, File? cover, Album? album) {
    if (album == null) {
      //is creating, only valid name
      return name.trim().isNotEmpty;
    } else {
      //is editing, name or cover is different then able to update
      if (name.trim() != album.name) return true;
      if (cover?.path != album.cover) return true;
      return false;
    }
  }
}