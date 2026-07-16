import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_state.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_detail_provider.g.dart';

@riverpod
class AlbumDetail extends _$AlbumDetail implements AlbumDetailNotifierITF {
  @override
  AlbumDetailState build(int? id) {
    if (id == null) return const AlbumDetailState.empty();
    final album = ref.watch(
      dbAlbumListProvider
          .select((av) => av.value ?? [])
          .select((al) => {for (final a in al) a.id: a})
          .select((am) => am[id]),
    );
    if (album == null) return const AlbumDetailState.empty();
    final coverPath = album.cover;
    return AlbumDetailState(
      name: album.name,
      cover: coverPath == null ? null : File(coverPath),
      mediaCount: album.medias.length,
      showImport: true,
    );
  }

  @override
  Future<void> import() async {
    final id = this.id;
    if (id == null) {
      return;
    }
    final files = await _pickMediasAndSubtitleFiles();
    final album = this.album;
    if (files.isNotEmpty && album != null) {
      EasyLoading.show(maskType: .clear);
      await ref
          .read(dbAlbumListProvider.notifier)
          .importResourcesIntoAlbum(album, files);
      EasyLoading.dismiss();
    }
  }

  @override
  Future<void> addCover() async {
    final id = this.id;
    if (id == null) {
      return;
    }
    final newCover = await _pickImage();
    if (newCover != null) {
      // state = const AsyncLoading();
      // await ref
      //     .read(dbAlbumProvider(id).notifier)
      //     .updateAlbum(cover: () => newCover);
    }
  }

  @override
  EnMedia? mediaAtIndex(int i) {
    final id = this.id;
    if (id == null) {
      return null;
    }
    return album?.medias.elementAtOrNull(i);
  }

  EnAlbum? get album {
    return ref.read(
      dbAlbumListProvider
          .select((av) => av.value ?? [])
          .select((al) => {for (final a in al) a.id: a})
          .select((am) => am[id]),
    );
  }

  Future<List<File>> _pickMediasAndSubtitleFiles() async {
    try {
      final allowedExtensions = [
        ...kAudioExtensions,
        ...kVideoExtensions,
        ...kSubtitleExtensions,
      ];
      final pickedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (pickedFiles == null || pickedFiles.files.isEmpty) {
        return [];
      }
      final files = pickedFiles.files
          .map((f) => f.path)
          .whereType<String>()
          .map((p) => File(p))
          .toList();
      return files;
    } catch (e) {
      debugPrint('Error importing media files: $e');
      return [];
    }
  }

  Future<File?> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? xImage = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      final path = xImage?.path;
      return path == null ? null : File(path);
    } catch (e) {
      debugPrint('Error picking cover: $e');
      return null;
    }
  }
}
