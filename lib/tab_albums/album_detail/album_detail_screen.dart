import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart'; // 👈 确保顶部导了这个包
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/db/db_album.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/db_media.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/model/media.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_ui.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_state.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';

import 'album_detail_state.dart';

class AlbumDetailScreen extends StatefulWidget {
  final int _albumId;

  const AlbumDetailScreen(this._albumId, {super.key});

  @override
  State<AlbumDetailScreen> createState() =>
      _AlbumDetailScreenState();
}

class _AlbumDetailScreenState
    extends State<AlbumDetailScreen>
    implements AlbumDetailUIOutputITF {
  var _state = const AlbumDetailState.empty();
  Album? _album;
  final _subs = <StreamSubscription>[];
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return AlbumDetailUI(_state, this);
  }

  @override
  void dispose() {
    _cancelAllSubs();
    super.dispose();
  }

  void _cancelAllSubs() {
    for (final sub in _subs) {
      sub.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _subs.add(_watchAlbum(_reloadAlbum));
    _reloadAlbum();
  }

  StreamSubscription<void> _watchAlbum(void Function() f) {
    return DBObjectBox().store.watch<Album>().listen(
      (event) => f(),
    );
  }

  Future<void> _reloadAlbum() async {
    setState(() {
      _state = _state.copyWith(showLoading: true);
    });
    final album = await DBAlbum(
      DBObjectBox().store,
    ).get(widget._albumId);
    _album = album;
    if (album == null) {
      setState(() {
        _state = const AlbumDetailState.empty().copyWith(
          showLoading: false,
          showImport: false,
        );
      });
      return;
    }
    album.medias.sort(
      (a, b) => a.name.toLowerCase().compareTo(
        b.name.toLowerCase(),
      ),
    );
    //TODO playing index should be init correctly
    final mediaStates = album.medias
        .map((m) => m.toCardState())
        .toList();
    setState(() {
      final coverPath = album.cover;
      _state = AlbumDetailState(
        showImport: true,
        showLoading: false,
        name: album.name,
        cover: coverPath == null ? null : File(coverPath),
        mediaStates: mediaStates,
      );
    });
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

      if (pickedFiles == null ||
          pickedFiles.files.isEmpty) {
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
    final album = _album;
    if (album == null) {
      debugPrint('album==null, can NOT import medias');
      return;
    }
    final files = await _pickMediasAndSubtitleFiles();
    await DBLogic().importMediaAndSubtitles(album, files);
  }

  @override
  void albumDetail_onPickCover() async {
    final album = _album;
    if (album == null) return;

    try {
      final XFile? xImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (xImage != null) {
        setState(() {
          _state = _state.copyWith(showLoading: true);
        });
        final newCover = File(xImage.path);
        await DBAlbum(
          DBObjectBox().store,
        ).update(album, album.name, newCover);
      }
    } catch (e) {
      debugPrint('Error picking cover: $e');
      setState(() {
        _state = _state.copyWith(showLoading: false);
      });
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
            (f) => kSubtitleExtensions.contains(
              f.extension?.toLowerCase() ?? '',
            ),
          )
          ?.path;
      return subtitlePath;
    } catch (e) {
      debugPrint('Error adding subtitle: $e');
      return null;
    }
  }

  @override
  void mediaCard_onAddSubtitle(int index) async {
    final album = _album;
    if (album == null) {
      debugPrint('album == null, can NOT add any subtitle');
      return;
    }
    final media = album.medias.elementAtOrNull(index);
    if (media == null) {
      debugPrint(
        'no media at index $index, can NOT add any subtitle',
      );
      return;
    }

    final subtitlePath = await _pickOneSubtitle();
    if (subtitlePath == null) {
      debugPrint('no subtitle files picked');
      return;
    }
    setState(() {
      _state = _state.copyWith(showLoading: true);
    });
    final subtitleFile = File(subtitlePath);
    final subtitle = await SubtitleParser.parseFile(
      subtitleFile,
    );
    await DBMedia(
      DBObjectBox().store,
    ).addSubtitle(media, subtitle);
  }

  @override
  void mediaCard_onDeleteMedia(int index) async {
    final album = _album;
    if (album == null) {
      debugPrint('album==null');
      return;
    }
    final media = album.medias.elementAtOrNull(index);
    if (media == null) {
      debugPrint('media==null at index $index');
      return;
    }
    setState(() {
      _state = _state.copyWith(showLoading: true);
    });
    await DBMedia(DBObjectBox().store).remove(media);
  }

  @override
  void mediaCard_onPlayMedia(int index) {
    final album = _album;
    if (album == null) {
      debugPrint('album==null');
      return;
    }
    final media = album.medias.elementAtOrNull(index);
    if (media == null) {
      debugPrint('media==null at index $index');
      return;
    }
    setState(() {
      final mediaStates = _state.mediaStates
          .asMap()
          .entries
          .map((e) {
            int i = e.key;
            final ms = e.value;
            return ms.copyWith(isPlaying: i == index);
          })
          .toList();
      _state = _state.copyWith(mediaStates: mediaStates);
    });
    context.go(AppRoute.playerById(media.id));
  }

  @override
  void mediaCard_onRemoveSubtitle(int index) async {
    final album = _album;
    if (album == null) {
      debugPrint('album==null');
      return;
    }
    final media = album.medias.elementAtOrNull(index);
    if (media == null) {
      debugPrint('media==null at index $index');
      return;
    }
    setState(() {
      _state = _state.copyWith(showLoading: true);
    });
    //TODO move these DB methods to DBLogic layer
    await DBMedia(
      DBObjectBox().store,
    ).removeSubtitle(media);
  }
}

//TODO optimize codes to use this kind way to create states
extension on Media {
  MediaCardState toCardState() {
    return MediaCardState(
      name: name,
      type: type,
      hasSubtitle: subtitles.isNotEmpty,
      isPlaying: false,
    );
  }
}
