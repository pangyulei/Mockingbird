import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart'; // 👈 确保顶部导了这个包
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:mockingbird/tab_albums/album/album_provider.dart';
import 'package:mockingbird/tab_albums/album/album_ui.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_screen.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_state.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';

import 'album_state.dart';

class AlbumScreen extends ConsumerStatefulWidget {
  final int _id;

  const AlbumScreen(this._id, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends ConsumerState<AlbumScreen>
    implements AlbumDetailUIOutputITF {
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return AlbumUI(widget._id, this);
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

  @override
  void albumDetail_onImport() async {
    final files = await _pickMediasAndSubtitleFiles();
    ref.read(albumProvider(widget._id).notifier).import(files);
  }

  @override
  void albumDetail_onPickCover() async {
    final newCover = await _pickImage();
    if (newCover != null) {
      ref.read(albumProvider(widget._id).notifier).addCover(newCover);
    }
  }

  @override
  void albumDetail_onEditAlbum() async {
    await _showEditingAlbumDialog(widget._id);
  }

  Future<void> _showEditingAlbumDialog(int id) async {
    await showDialog(
      context: context,
      builder: (context) {
        return EditAlbumScreen(id);
      },
    );
  }

  Future<File?> _pickImage() async {
    try {
      final XFile? xImage = await _picker.pickImage(
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

  Future<String?> _pickOneSubtitle() async {
    try {
      final pickedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [...kSubtitleExtensions],
        allowMultiple: false,
      );
      final subtitlePath = pickedFiles?.files
          .firstWhereOrNull(
            (f) =>
                kSubtitleExtensions.contains(f.extension?.toLowerCase() ?? ''),
          )
          ?.path;
      return subtitlePath;
    } catch (e) {
      debugPrint('Error adding subtitle: $e');
      return null;
    }
  }

  @override
  void mediaCard_onAddSubtitle(int i) async {
    final subtitlePath = await _pickOneSubtitle();
    if (subtitlePath == null) {
      debugPrint('no subtitle files picked');
      return;
    }
    final subtitle = await SubtitleParser.parsePath(subtitlePath);
    if (subtitle != null) {
      await ref
          .read(albumProvider(widget._id).notifier)
          .addSubtitle(i, subtitle);
    }
  }

  @override
  void mediaCard_onDeleteMedia(int i) async {
    await ref.read(albumProvider(widget._id).notifier).deleteMedia(i);
  }

  @override
  void mediaCard_onPlayMedia(int i) async {
    final mediaId = ref.read(albumProvider(widget._id).notifier).mediaIdAtIndex(i);
    if (mediaId != null) {
      context.go(AppRoute.playerById(mediaId));
    }
  }

  @override
  void mediaCard_onRemoveSubtitle(int i) async {
    await ref.read(albumProvider(widget._id).notifier).deleteSubtitle(i);
  }
}
