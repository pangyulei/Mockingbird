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
  EnAlbum get _album => ref.read(
    dbAlbumListProvider
        .select((st) => st.value ?? [])
        .select((al) => {for (final a in al) a.id: a})
        .select((am) => am[id]!),
  );

  @override
  Future<AlbumDetailState> build(int? id) async {
    if (id == null) return const AlbumDetailNull();
    final EnAlbum? album = await ref.watch(
      dbAlbumListProvider
          .selectAsync((al) => {for (final a in al) a.id: a}[id])
    );
    if (album == null) return const AlbumDetailNull();
    final coverPath = album.cover;
    return AlbumDetailData(
      name: album.name,
      cover: coverPath == null ? null : File(coverPath),
      mediaIdList: album.mediaList.map((m) => m.id).toList(),
    );
  }

  Future<void> import() async {
    final files = await _pickMediasAndSubtitleFiles();
    await ref
        .read(dbAlbumListProvider.notifier)
        .importResourcesIntoAlbum(_album, files);
  }

  Future<void> addCover() async {
    final newCover = await _pickImage();
    //newCover==null means didnt pick
    if (newCover != null) {
      await ref
          .read(dbAlbumListProvider.notifier)
          .updateAlbum(_album, cover: () => newCover);
    }
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
