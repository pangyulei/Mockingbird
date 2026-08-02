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

    ref.listen(dbPlayingMediaProvider.select((st) => st.value), (
      previous,
      media,
    ) {
      if (media == null) return;
      final album = media.albumList.first;
      handler.mb_updateMediaItem(
        MediaItem(
          id: media.id.toString(),
          title: media.name,
          album: album.name,
          duration: mediaController.mb_duration,
          artUri: album.cover?.toUri(),
        ),
      );
    }, fireImmediately: true);

    return handler;
  }
}

extension on String {
  Uri toUri() {
    return Uri.file(this);
  }
}