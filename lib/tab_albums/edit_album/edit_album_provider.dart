import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_state.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_album_provider.g.dart';

@Riverpod()
class EditAlbum extends _$EditAlbum implements EditAlbumNotifierITF {
  late final TextEditingController _nameController;
  @override
  EditAlbumState build(EnAlbum? album) {
    _nameController = TextEditingController();
    debugPrint('edit album provider build:\n$album\n');
    ref.onDispose(() {
      debugPrint('edit album provider dispose:\n$album\n');
      _nameController.dispose();
    });
    if (album == null) {
      _nameController.text = '';
      return EditAlbumState.add(_nameController);
    } else {
      _nameController.text = album.name;
      final cover = album.cover;
      return EditAlbumState.edit(
        cover == null ? null : File(cover),
        _nameController,
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
    EasyLoading.dismiss();
  }

  @override
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

  @override
  void removeCover() {
    _updateCover(null);
  }

  void _updateCover(File? newCover) {
    if (newCover?.path != state.cover?.path) {
      final enableSubmit = _isSubmitEnable(
        state.nameController.text,
        newCover,
        album,
      );
      state = state.copyWith(cover: () => newCover, enableSubmit: enableSubmit);
    }
  }

  @override
  void updateName(String newName) {
    final enableSubmit = _isSubmitEnable(newName, state.cover, album);
    state = state.copyWith(enableSubmit: enableSubmit);
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
