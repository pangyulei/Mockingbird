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
    ref.read(albumProvider(widget._id).notifier).onImport(files);
  }

  @override
  void albumDetail_onPickCover() async {
    // final album = _album;
    // if (album == null) return;

    // try {
    //   final XFile? xImage = await _picker.pickImage(
    //     source: ImageSource.gallery,
    //     maxWidth: 512,
    //     maxHeight: 512,
    //     imageQuality: 75,
    //   );

    //   if (xImage != null) {
    //     setState(() {
    //       _state = _state.copyWith(showLoading: true);
    //     });
    //     final newCover = File(xImage.path);
    //     await DBLogic().updateAlbum(album, cover: () => newCover);
    //   }
    // } catch (e) {
    //   debugPrint('Error picking cover: $e');
    //   setState(() {
    //     _state = _state.copyWith(showLoading: false);
    //   });
    // }
  }

  Future<String?> _pickOneSubtitle() async {
    // try {
    //   final pickedFiles = await FilePicker.pickFiles(
    //     type: FileType.custom,
    //     allowedExtensions: [...kSubtitleExtensions],
    //     allowMultiple: false,
    //   );
    //   final subtitlePath = pickedFiles?.files
    //       .firstWhereOrNull(
    //         (f) =>
    //             kSubtitleExtensions.contains(f.extension?.toLowerCase() ?? ''),
    //       )
    //       ?.path;
    //   return subtitlePath;
    // } catch (e) {
    //   debugPrint('Error adding subtitle: $e');
    //   return null;
    // }
  }

  @override
  void mediaCard_onAddSubtitle(int index) async {
    // final album = _album;
    // if (album == null) {
    //   debugPrint('album == null, can NOT add any subtitle');
    //   return;
    // }
    // final media = album.medias.elementAtOrNull(index);
    // if (media == null) {
    //   debugPrint('no media at index $index, can NOT add any subtitle');
    //   return;
    // }

    // final subtitlePath = await _pickOneSubtitle();
    // if (subtitlePath == null) {
    //   debugPrint('no subtitle files picked');
    //   return;
    // }
    // setState(() {
    //   _state = _state.copyWith(showLoading: true);
    // });
    // final subtitleFile = File(subtitlePath);
    // final subtitle = await SubtitleParser.parseFile(subtitleFile);
    // await DBLogic().addSubtitle(media, subtitle);
  }

  @override
  void mediaCard_onDeleteMedia(int index) async {
    // final album = _album;
    // if (album == null) {
    //   debugPrint('album==null');
    //   return;
    // }
    // final media = album.medias.elementAtOrNull(index);
    // if (media == null) {
    //   debugPrint('media==null at index $index');
    //   return;
    // }
    // setState(() {
    //   _state = _state.copyWith(showLoading: true);
    // });
    // await DBLogic().deleteMedia(media);
  }

  @override
  void mediaCard_onPlayMedia(int index) {
    // final album = _album;
    // if (album == null) {
    //   debugPrint('album==null');
    //   return;
    // }
    // final media = album.medias.elementAtOrNull(index);
    // if (media == null) {
    //   debugPrint('media==null at index $index');
    //   return;
    // }
    // setState(() {
    //   final mediaStates = _state.mediaStates.asMap().entries.map((e) {
    //     int i = e.key;
    //     final ms = e.value;
    //     return ms.copyWith(isPlaying: i == index);
    //   }).toList();
    //   _state = _state.copyWith(mediaStates: mediaStates);
    // });
    // context.go(AppRoute.playerById(media.id));
  }

  @override
  void mediaCard_onRemoveSubtitle(int index) async {
    // final album = _album;
    // if (album == null) {
    //   debugPrint('album==null');
    //   return;
    // }
    // final media = album.medias.elementAtOrNull(index);
    // if (media == null) {
    //   debugPrint('media==null at index $index');
    //   return;
    // }
    // //TODO move these DB methods to DBLogic layer
    // await DBLogic().deleteSubtitle(media);
  }
}
