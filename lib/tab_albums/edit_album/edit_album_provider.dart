import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/album.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/db/providers/db_albums_provider.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_state.dart';

class EditAlbumAsyncNotifier extends AsyncNotifier<Album?> {
  final int? _id;
  Album? _album;
  EditAlbumAsyncNotifier(this._id);

  @override
  Future<Album?> build() async {
    ref.onDispose(() {
      debugPrint('EditAlbumAsyncNotifier ${identityHashCode(this)} disposed');
    });
    final id = _id;
    if (id == null) {
      return null;
    } else {
      _album = ref.watch(dbAlbumProvider(id)).value;
      return _album;
    }
  }

  Future<void> onSubmit() async {
    state = const AsyncLoading();
    final album = _album;
    if (album == null) {
      //creating
      await AsyncValue.guard(() async {
        final data = ref.read(editAlbumProvider(_id));
        await ref
            .read(dbAlbumsProvider.notifier)
            .createAlbum(data.name, cover: data.cover);
      });
    } else {
      //editing
      state = await AsyncValue.guard(() async {
        final data = ref.read(editAlbumProvider(_id));
        _album = await ref
            .read(dbAlbumsProvider.notifier)
            .updateAlbum(album, name: data.name, cover: () => data.cover);
        return _album;
      });
    }
  }
}

class EditAlbumNotifier extends Notifier<EditAlbumState> {
  final int? _id;
  EditAlbumNotifier(this._id);

  @override
  EditAlbumState build() {
    final album = _id == null ? null : ref.watch(dbAlbumProvider(_id)).value;
    if (album == null) {
      return const EditAlbumState.create();
    } else {
      final cover = album.cover;
      return EditAlbumState.edit(
        album.name,
        cover == null ? null : File(cover),
      );
    }
  }

  void onCoverChanged(File? newCover) {
    if (newCover?.path != state.cover?.path) {
      final album = _id == null ? null : ref.watch(dbAlbumProvider(_id)).value;
      final enableSubmit = _isSubmitEnable(state.name, newCover, album);
      state = state.copyWith(cover: () => newCover, enableSubmit: enableSubmit);
    }
  }

  void onNameChanged(String newName) {
    if (newName != state.name) {
      final album = _id == null ? null : ref.watch(dbAlbumProvider(_id)).value;
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

final editAlbumProvider = NotifierProvider.autoDispose
    .family<EditAlbumNotifier, EditAlbumState, int?>(EditAlbumNotifier.new);
final editAlbumAsyncProvider = AsyncNotifierProvider.autoDispose
    .family<EditAlbumAsyncNotifier, Album?, int?>(EditAlbumAsyncNotifier.new);
