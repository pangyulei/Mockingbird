import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/tab_player/player/background_audio_handler.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_controller_provider.dart';
import 'package:path/path.dart' as p;

//keepalive, never dispose
final backgroundAudioHandlerProvider = NotifierProvider(BackgroundAudioHandlerNotifier.new);

class BackgroundAudioHandlerNotifier extends Notifier<BackgroundAudioHandler> {
  @override
  BackgroundAudioHandler build() {
    ref.onDispose(() {
      assert(false, 'BackgroundAudioHandlerNotifier should never dispose');
    });
    // Use read instead of watch to avoid rebuilding the handler
    final mediaController = ref.read(playerMediaControllerProvider);
    final handler = BackgroundAudioHandler(mediaController);

    // ref.listen(dbPlayingMediaProvider.select((st) => st.value), (
    //   previous,
    //   media,
    // ) {
    //   if (media == null) return;
    //   final album = media.albumList.first;
    //   handler.mb_updateMediaItem(
    //     MediaItem(
    //       id: media.id.toString(),
    //       title: media.name,
    //       album: album.name,
    //       duration: mediaController.mb_duration,
    //       artUri: album.cover?.toUri(),
    //     ),
    //   );
    // }, fireImmediately: true);

    return handler;
  }

  Future<void> updateMediaItem() async {
    final asset = ref.read(dbPlayingMediaProvider.select((st) => st.value));
    if (asset == null) {
      state.setup(item: null, playing: false, position: const Duration(seconds: 0));
    } else {
      final path = (await asset.file)?.path ?? '';
      final album = p.basename(p.dirname(path));
      final (playing, position) = ref.read(
        playerMediaControllerProvider.select((st) => (st.playing, st.position)),
      );
      state.setup(
        item: MediaItem(
          id: asset.id,
          title: await asset.titleAsync,
          album: album,
          duration: asset.videoDuration,
          artUri: null, //TODO fix artUri
        ),
        playing: playing,
        position: position,
      );
    }
  }
}

