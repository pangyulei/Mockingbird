import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/tab_albums/album/album_state.dart';
import 'package:mockingbird/tab_albums/album/album_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_provider.g.dart';

@riverpod
class Album extends _$Album implements AlbumNotifierITF {
  @override
  Future<AlbumState> build(int? id) async {
    debugPrint('albumProvider($id) build');
    ref.onDispose(() {
      debugPrint('albumProvider($id) disposed');
    });
    if (id == null) return const AlbumState.empty();
    final album = await ref.watch(dbAlbumProvider(id).future);
    if (album == null) return const AlbumState.empty();
    final coverPath = album.cover;
    return AlbumState(
      name: album.name,
      cover: coverPath == null ? null : File(coverPath),
      mediaCount: album.medias.length,
    );
  }

  @override
  Future<void> import() async {
    final id = this.id;
    if (id == null) {
      return;
    }
    final files = await _pickMediasAndSubtitleFiles();
    if (files.isNotEmpty) {
      state = const AsyncLoading();
      await ref.read(dbAlbumProvider(id).notifier).importMediasSubtitles(files);
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
      state = const AsyncLoading();
      await ref
          .read(dbAlbumProvider(id).notifier)
          .updateAlbum(cover: () => newCover);
    }
  }

  @override
  int? mediaIdAtIndex(int i) {
    final id = this.id;
    if (id == null) {
      return null;
    }
    final album = ref.read(dbAlbumProvider(id)).value;
    return album?.medias.elementAtOrNull(i)?.id;
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
