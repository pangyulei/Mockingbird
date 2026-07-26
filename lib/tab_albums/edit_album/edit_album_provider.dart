import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_album_provider.g.dart';

@riverpod
class EditAlbum extends _$EditAlbum {
  @override
  Future<EditAlbumState> build(int? id) async {
    final EnAlbum? album = await ref.watch(dbAlbumProvider(id).future);
    if (album == null) {
      return const EditAlbumState.add();
    } else {
      final coverPath = album.cover;
      final cover = coverPath == null || coverPath.isEmpty
          ? null
          : File(coverPath);
      return EditAlbumState.edit(album.name, cover);
    }
  }

  Future<void> submit() async {
    final album = ref.read(dbAlbumProvider(id)).value;
    final name = state.value?.name;
    if (name == null) return;
    if (album == null) {
      //creating
      await ref
          .read(dbAlbumListProvider.notifier)
          .addAlbum(name, cover: state.value?.cover);
    } else {
      //editing
      await ref
          .read(dbAlbumProvider(id).notifier)
          .edit(name: name, cover: () => state.value?.cover);
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
    var data = state.value;
    if (data == null) return;
    if (newCover?.path != data.cover?.path) {
      final album = ref.read(dbAlbumProvider(id)).value;
      final enableSubmit = _isSubmitEnable(album, data.name, newCover);
      data = data.copyWith(cover: () => newCover, enableSubmit: enableSubmit);
      state = AsyncData(data);
    }
  }

  void updateName(String newName) {
    var data = state.value;
    if (data == null) return;
    final album = ref.read(dbAlbumProvider(id)).value;
    final enableSubmit = _isSubmitEnable(album, newName, data.cover);
    state = AsyncData(data.copyWith(name: newName, enableSubmit: enableSubmit));
  }

  bool _isSubmitEnable(EnAlbum? album, String? newName, File? newCover) {
    if (newName == null) return false;
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
