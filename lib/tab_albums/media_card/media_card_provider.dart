import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/providers/db_media_provider.dart';
import 'package:mockingbird/db/providers/db_metadata_provider.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_card_provider.g.dart';

@riverpod
class MediaCard extends _$MediaCard {
  @override
  MediaCardState build(String id) {
    // For now, we assume these are system assets because they come from folder browsing
    final media = ref.watch(dbMediaProvider(id)).value;
    if (media == null) return const MediaCardState.empty();
    final playingMediaId = ref.watch(dbPlayingMediaProvider.select((st)=>st.value?.id));
    return MediaCardState(
      name: media.title ?? '',
      type: media.type,
      playing: id == playingMediaId,
    );
  }

  Future<void> play() async {
    await ref.read(dbMetadataProvider.notifier).setPlayingMediaId(id);
  }
}
