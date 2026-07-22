import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_detail_provider.g.dart';

@riverpod
class AlbumDetail extends _$AlbumDetail {
  EnAlbum? get _album => ref.read(
      dbAlbumListProvider
          .select((st) => st.value ?? [])
          .select((al) => {for (final a in al) a.id: a})
          .select((am) => am[id]),
    );

  @override
  AlbumDetailState build(int? id) {
    if (id == null) return const AlbumDetailState.empty();
    final album = ref.watch(
      dbAlbumListProvider
          .select((st) => st.value ?? [])
          .select((al) => {for (final a in al) a.id: a})
          .select((am) => am[id]),
    );
    if (album == null) return const AlbumDetailState.empty();
    final coverPath = album.cover;
    return AlbumDetailState(
      name: album.name,
      cover: coverPath == null ? null : File(coverPath),
      mediaCount: album.mediaList.length,
      showImport: true,
    );
  }

  Future<void> import() async {
    final id = this.id;
    if (id == null) {
      return;
    }
    final files = await _pickMediasAndSubtitleFiles();
    final album = _album;
    if (files.isNotEmpty && album != null) {
      await ref.read(dbAlbumListProvider.notifier).importResourcesIntoAlbum(album, files);
      
    }
  }

  Future<void> addCover() async {
    final id = this.id;
    if (id == null) {
      return;
    }
    final newCover = await _pickImage();
    final album = _album;
    if (newCover != null && album != null) {
      await ref.read(dbAlbumListProvider.notifier).updateAlbum(album, cover: () => newCover);
      
    }
  }

  int? mediaIdAtIndex(int i) {
    return _album?.mediaList.elementAtOrNull(i)?.id;
  }

  Future<List<File>> _pickMediasAndSubtitleFiles() async {
    try {
      final allowedExtensions = [...kAudioExtensions, ...kVideoExtensions, ...kSubtitleExtensions];
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
