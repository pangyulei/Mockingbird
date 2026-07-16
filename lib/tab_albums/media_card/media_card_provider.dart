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
  Future<MediaCardState> build(EnMedia? media) async {
    if (media == null) return const MediaCardState.empty();
    return media.toCardState();
  }

  @override
  Future<void> deleteSubtitle() async {
    // final id = media?.id;
    // if (id == null) return;
    // state = const AsyncLoading();
    // await ref.read(dbMediaProvider(id).notifier).deleteSubtitle();
  }

  @override
  Future<void> addSubtitle(EnSubtitle subtitle) async {
    // final id = media?.id;
    // if (id == null) return;
    // state = const AsyncLoading();
    // await ref.read(dbMediaProvider(id).notifier).addSubtitle(subtitle);
  }

  @override
  Future<void> deleteMedia() async {
    // final id = media?.id;
    // if (id == null) return;
    // state = const AsyncLoading();
    // await ref.read(dbMediaProvider(id).notifier).delete();
  }

  @override
  Future<void> play() async {
    final id = media?.id;
    if (id == null) return;
    await ref.read(dbPrefProvider.notifier).setPlayingId(id);
    final data = state.value;
    if (data == null) return;
    state = AsyncData(data.copyWith(isPlaying: true));
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
