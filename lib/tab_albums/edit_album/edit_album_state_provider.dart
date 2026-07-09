import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/album.dart';
import 'package:mockingbird/db/providers/album_provider.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_state.dart';

class EditAlbumStateNotifier extends Notifier<EditAlbumState> {
  final int? _id;
  Album? _album;
  EditAlbumStateNotifier(this._id);

  @override
  EditAlbumState build() {
    ref.onDispose(() {
      debugPrint('EditAlbumNotifier ${identityHashCode(this)} disposed');
    });
    final id = _id;
    if (id == null) {
      //create album
      return const EditAlbumState.create();
    } else {
      //edit album
      final av = ref.watch(albumProvider(id));
      final album = av.value;
      _album = album;
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
  }

  Future<void> onSubmit() async {
    final album = _album;
    state = state.copyWith(isLoading: true);
    if (album == null) {
      //creating
      await DBLogic().createAlbum(state.name, cover: state.cover);
    } else {
      //editing
      await DBLogic().updateAlbum(
        album,
        name: state.name,
        cover: () => state.cover,
      );
    }
    state = state.copyWith(isLoading: false);
  }

  void onCoverChanged(File? newCover) {
    if (newCover?.path != state.cover?.path) {
      final enableSubmit = _isSubmitEnable(state.name, newCover, _album);
      state = state.copyWith(cover: () => newCover, enableSubmit: enableSubmit);
    }
  }

  void onNameChanged(String newName) {
    final enableSubmit = _isSubmitEnable(newName, state.cover, _album);
    if (state.enableSubmit != enableSubmit) {
      state = state.copyWith(enableSubmit: enableSubmit);
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

final editAlbumStateProvider = NotifierProvider.autoDispose
    .family<EditAlbumStateNotifier, EditAlbumState, int?>(
      EditAlbumStateNotifier.new,
    );
