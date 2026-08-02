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
      state.mb_update(
        item: null,
        isPlaying: false,
        isBuffering: false,
        position: const Duration(seconds: 0),
      );
    } else {
      final album = media.albumList.first;
      final (isPlaying, isBuffering, position, duration) = ref.read(
        playerMediaControllerProvider.select(
          (st) => (
            st.mb_isPlaying,
            st.mb_isBuffering,
            st.mb_position,
            st.mb_duration,
          ),
        ),
      );
      state.mb_update(
        item: MediaItem(
          id: media.id.toString(),
          title: media.name,
          album: album.name,
          duration: duration,
          artUri: album.cover?.toUri(),
        ),
        isPlaying: isPlaying,
        isBuffering: isBuffering,
        position: duration,
      );
    }
  }
}

extension on String {
  Uri toUri() {
    return Uri.file(this);
  }
}
