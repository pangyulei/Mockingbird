import 'package:flutter/widgets.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/entities/en_subtitle.dart';
import 'package:mockingbird/db/providers/db_media_provider.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_state.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_card_provider.g.dart';

@riverpod
class MediaCard extends _$MediaCard implements MediaCardNotifierITF {
  @override
  Future<MediaCardState> build(int? id) async {
    debugPrint('media card ($id) build');
    ref.onDispose(() {
      debugPrint('media card ($id) dispose');
    });
    if (id == null) return const MediaCardState.empty();
    final media = await ref.watch(dbMediaProvider(id).future);
    if (media == null) return const MediaCardState.empty();
    return media.toCardState();
  }

  @override
  Future<void> deleteSubtitle() async {
    final id = this.id;
    if (id == null) {
      return;
    }
    state = const AsyncLoading();
    await ref.read(dbMediaProvider(id).notifier).deleteSubtitle();
  }

  @override
  Future<void> addSubtitle(EnSubtitle subtitle) async {
    final id = this.id;
    if (id == null) {
      return;
    }
    state = const AsyncLoading();
    await ref.read(dbMediaProvider(id).notifier).addSubtitle(subtitle);
  }

  @override
  Future<void> deleteMedia() async {
    final id = this.id;
    if (id == null) {
      return;
    }
    state = const AsyncLoading();
    await ref.read(dbMediaProvider(id).notifier).delete();
  }

  @override
  Future<void> play() async {
    final id = this.id;
    if (id == null) return;
    final media = ref.read(dbMediaProvider(id)).value;
    if (media == null) return;
    state = await AsyncValue.guard(() async {
      await ref.read(dbPrefProvider.notifier).setPlayingId(id);
      return state.value?.copyWith(isPlaying: true) ??
          const MediaCardState.empty();
    });
  }
}

extension on EnMedia {
  MediaCardState toCardState() {
    return MediaCardState(
      name: name,
      type: type,
      hasSubtitle: subtitles.isNotEmpty,
      isPlaying: false,
    );
  }
}
