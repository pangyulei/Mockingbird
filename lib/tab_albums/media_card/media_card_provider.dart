import 'package:mockingbird/db/providers/db_media_provider.dart';
import 'package:mockingbird/db/providers/db_metadata_provider.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_card_provider.g.dart';

@riverpod
class MediaCard extends _$MediaCard {
  @override
  Future<MediaCardState?> build(String id) async {
    // For now, we assume these are system assets because they come from folder browsing
    final asset = await ref.watch(dbMediaProvider(id).future);
    if (asset == null) return null;

    return MediaCardState(
      name: asset.title ?? '',
      type: asset.type,
      playing: false,
    );
  }

  Future<void> play() async {
    await ref.read(dbMetadataProvider.notifier).setPlayingMediaId(id);
  }
}
