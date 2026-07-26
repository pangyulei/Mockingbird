import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_album_provider.g.dart';

@riverpod
class EditAlbum extends _$EditAlbum {
  EditAlbumData get _data => state.value as EditAlbumData;

  @override
  Future<EditAlbumState> build(int? id) async {
    final nameController = TextEditingController();
      debugPrint('editalbum($id) create, namecontroller:${identityHashCode(nameController)}');
    ref.onDispose(() {
      debugPrint('editalbum($id) dispose, namecontroller:${identityHashCode(nameController)}');
      nameController.dispose();
    });
    final EnAlbum? album = await ref.watch(dbAlbumProvider(id).future);
    if (album == null) {
      return EditAlbumData.add(nameController);
    } else {
      nameController.text = album.name;
      final cover = album.cover;
      return EditAlbumData.edit(
        cover == null ? null : File(cover),
        nameController,
      );
    }
  }

  Future<void> submit() async {
    final album = ref.read(dbAlbumProvider(id)).value;
    if (album == null) {
      //creating
      await ref
          .read(dbAlbumListProvider.notifier)
          .addAlbum(_data.nameController.text, cover: _data.cover);
    } else {
      //editing
      await ref
          .read(dbAlbumProvider(id).notifier)
          .edit(name: _data.nameController.text, cover: () => _data.cover);
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
    if (newCover?.path != _data.cover?.path) {
      final album = ref.read(dbAlbumProvider(id)).value;
      final enableSubmit = _isSubmitEnable(
        album,
        _data.nameController.text,
        newCover,
      );
      state = AsyncData(
        _data.copyWith(cover: () => newCover, enableSubmit: enableSubmit),
      );
    }
  }

  void updateName(String newName) {
    final album = ref.read(dbAlbumProvider(id)).value;
    final enableSubmit = _isSubmitEnable(album, newName, _data.cover);
    state = AsyncData(_data.copyWith(enableSubmit: enableSubmit));
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
