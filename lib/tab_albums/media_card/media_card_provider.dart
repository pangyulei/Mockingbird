import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/providers/db_media_provider.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_state.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_card_provider.g.dart';

@riverpod
class MediaCard extends _$MediaCard {
  @override
  Future<MediaCardState?> build(int? id) async {
    final EnMedia? media = await ref.watch(dbMediaProvider(id).future);
    debugPrint('${identityHashCode(media)} $media');
    if (media == null) return null;
    final playingId = ref.watch(
      dbPrefProvider.select((st) => st.value?.playingId),
    );
    return MediaCardState(
      name: media.name,
      type: media.type,
      hasSubtitle: media.subtitleList.isNotEmpty,
      isPlaying: media.id == playingId,
    );
  }

  Future<void> deleteSubtitle() async {
    await ref.read(dbMediaProvider(id).notifier).edit(subtitle: () => null);
  }

  Future<void> updateSubtitle() async {
    final subtitlePath = await _pickOneSubtitle();
    if (subtitlePath == null) return;

    final subtitle = await SubtitleParser.parsePath(subtitlePath);
    if (subtitle != null) {
      await ref
          .read(dbMediaProvider(id).notifier)
          .edit(subtitle: () => subtitle);
    }
  }

  Future<void> addSubtitle() async {
    await updateSubtitle();
  }

  Future<void> deleteMedia() async {
    await ref.read(dbMediaProvider(id).notifier).delete();
  }

  Future<void> play() async {
    await ref.read(dbPrefProvider.notifier).setPlayingId(id);
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
}
