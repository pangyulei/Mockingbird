import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/tab_player/player/background_audio_handler.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_controller_provider.dart';

//keepalive, never dispose
final backgroundAudioHandlerProvider = NotifierProvider(
  BackgroundAudioHandlerNotifier.new,
);

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

  void updateMediaItem() {
    final media = ref.read(dbPlayingMediaProvider.select((st) => st.value));
    if (media == null) {
      state.setup(
        item: null,
        playing: false,
        position: const Duration(seconds: 0),
      );
    } else {
      final album = media.albumList.first;
      final (playing, position, duration) = ref.read(
        playerMediaControllerProvider.select(
          (st) => (st.playing, st.position, st.duration),
        ),
      );
      state.setup(
        item: MediaItem(
          id: media.id.toString(),
          title: media.name,
          album: album.name,
          duration: duration,
          artUri: album.cover?.toUri(),
        ),
        playing: playing,
        position: position,
      );
    }
  }
}

extension on String {
  Uri toUri() {
    return Uri.file(this);
  }
}
