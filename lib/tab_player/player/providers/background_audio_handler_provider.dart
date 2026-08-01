import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final mediaController = ref.watch(playerMediaControllerProvider);
    return BackgroundAudioHandler(mediaController);
  }

  void updateMedia(String? id, String? title) {
    state.mediaItem.add(MediaItem(id: id ?? '', title: 'Mockingbird'));
  }
}
