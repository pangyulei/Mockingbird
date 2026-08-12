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
    //TODO这里用 mediaController会不会造成play pause ui不一致的问题
    final handler = BackgroundAudioHandler(mediaController);
    return handler;
  }

  Future<void> updateMediaItem() async {
    final media = ref.read(dbPlayingMediaProvider.select((st) => st.value));
    if (media == null) {
      state.setup(item: null, playing: false, position: const Duration(seconds: 0));
    } else {
      final path = (await media.file)?.path ?? '';
      final album = p.basename(p.dirname(path));
      final (playing, position) = ref.read(
        playerMediaControllerProvider.select((st) => (st.playing, st.position)),
      );
      state.setup(
        item: MediaItem(
          id: media.id,
          title: await media.titleAsync,
          album: album,
          duration: media.videoDuration,
          artUri: null, //TODO fix artUri
        ),
        playing: playing,
        position: position,
      );
    }
  }
}

