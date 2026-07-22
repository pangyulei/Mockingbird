import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_album_provider.g.dart';

@riverpod
class EditAlbum extends _$EditAlbum {
  EnAlbum? get _album => ref.read(
    dbAlbumListProvider
        .select((st) => st.value ?? [])
        .select((al) => {for (final a in al) a.id: a})
        .select((am) => am[id]),
  );

  @override
  EditAlbumState build(int? id) {
    final nameController = TextEditingController();
    ref.onDispose(() {
      nameController.dispose();
    });
    if (id == null) return EditAlbumState.add(nameController);
    final album = ref.watch(
      dbAlbumListProvider
          .select((st) => st.value ?? [])
          .select((al) => {for (final a in al) a.id: a})
          .select((am) => am[id]),
    );
    if (album == null) {
      return EditAlbumState.add(nameController);
    } else {
      nameController.text = album.name;
      final cover = album.cover;
      return EditAlbumState.edit(
        cover == null ? null : File(cover),
        nameController,
      );
    }
  }

  Future<void> submit() async {
    final album = _album;
    if (album == null) {
      //creating
      await ref
          .read(dbAlbumListProvider.notifier)
          .addAlbum(state.nameController.text, cover: state.cover);
    } else {
      //editing
      await ref
          .read(dbAlbumListProvider.notifier)
          .updateAlbum(
            album,
            name: state.nameController.text,
            cover: () => state.cover,
          );
    }
  }

  Future<void> pickCover() async {
    final XFile? xImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    if (xImage == null) {
      //didnt select any image, no changes
      return;
    }
    File newCover = File(xImage.path);
    _updateCover(newCover);
  }

  void removeCover() {
    _updateCover(null);
  }

  void _updateCover(File? newCover) {
    if (newCover?.path != state.cover?.path) {
      final enableSubmit = _isSubmitEnable(
        _album,
        state.nameController.text,
        newCover,
      );
      state = state.copyWith(
        getCover: () => newCover,
        enableSubmit: enableSubmit,
      );
    }
  }

  void updateName(String newName) {
    final enableSubmit = _isSubmitEnable(_album, newName, state.cover);
    state = state.copyWith(enableSubmit: enableSubmit);
  }

  bool _isSubmitEnable(EnAlbum? album, String newName, File? newCover) {
    final trimmedNewName = newName.trim();
    if (trimmedNewName.isEmpty) {
      return false;
    }
    if (album == null) {
      //is creating, only valid name
      return true;
    }
    //is editing, name or cover is different then able to update
    if (trimmedNewName != album.name) return true;
    if (newCover?.path != album.cover) return true;
    return false;
  }
}
