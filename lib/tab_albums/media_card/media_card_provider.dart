import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_state.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_card_provider.g.dart';

@riverpod
class MediaCard extends _$MediaCard {
  EnMedia? _media;

  @override
  MediaCardState build(int? id) {
    if (id == null) return const MediaCardState.empty();
    final EnMedia? media = ref.watch(
      dbAlbumListProvider
          .select((st) => st.value ?? [])
          .select((al) => [for (final a in al) a.mediaList])
          .select((mll) => mll.expand((e) => e))
          .select((ml) => {for (final m in ml) m.id: m})
          .select((mm) => mm[id]),
    );
    _media = media;
    debugPrint('${identityHashCode(media)} $media');
    if (media == null) return const MediaCardState.empty();
    final playingId = ref.watch(dbPrefProvider.select((st) => st.value?.playingId));
    return MediaCardState(
      name: media.name,
      type: media.type,
      hasSubtitle: media.subtitleList.isNotEmpty,
      isPlaying: media.id == playingId,
    );
  }

  Future<void> deleteSubtitle() async {
    final media = _media;
    if (media == null) return;
    EasyLoading.show(maskType: .clear);
    await ref.read(dbAlbumListProvider.notifier).updateMedia(media, subtitle: () => null);
    EasyLoading.dismiss();
  }

  Future<void> updateSubtitle() async {
    final media = _media;
    if (media == null) return;
    final subtitlePath = await _pickOneSubtitle();
    if (subtitlePath == null) return;

    EasyLoading.show(maskType: .clear);
    final subtitle = await SubtitleParser.parsePath(subtitlePath);
    if (subtitle != null) {
      await ref.read(dbAlbumListProvider.notifier).updateMedia(media, subtitle: () => subtitle);
    }
    EasyLoading.dismiss();
  }

  Future<void> addSubtitle() async {
    await updateSubtitle();
  }

  Future<void> deleteMedia() async {
    final media = _media;
    if (media == null) return;
    EasyLoading.show(maskType: .clear);
    await ref.read(dbAlbumListProvider.notifier).deleteMedia(media);
    EasyLoading.dismiss();
  }

  Future<void> play() async {
    EasyLoading.show(maskType: .clear);
    await ref.read(dbPrefProvider.notifier).setPlayingId(id);
    EasyLoading.dismiss();
  }

  Future<String?> _pickOneSubtitle() async {
    try {
      final pickedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [...kSubtitleExtensions],
        allowMultiple: false,
      );
      final subtitlePath = pickedFiles?.files
          .firstWhereOrNull((f) => kSubtitleExtensions.contains(f.extension?.toLowerCase() ?? ''))
          ?.path;
      return subtitlePath;
    } catch (e) {
      debugPrint('Error adding subtitle: $e');
      return null;
    }
  }
}
