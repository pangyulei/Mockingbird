import 'package:flutter/material.dart';
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
    final mediaController = ref.read(playerMediaControllerProvider);
    final handler = BackgroundAudioHandler(mediaController);
    // final mediaInfo = ref.read(
    //   dbPlayingMediaProvider
    //       .select((st) => st.value)
    //       .select((m) => m == null ? null : (m.id, m.name)),
    // );
    // if (mediaInfo != null) {
    //   final (id, name) = mediaInfo;
    //   handler.updateMedia(id.toString(), name);
    // }
    _listen();
    return handler;
  }

  void _listen() {
    ref.listen(dbPlayingMediaProvider.select((st) => st.value), (_, media) {
      debugPrint('bg media: $media state: $state');
      if (media == null) return;
      state.updateMedia(media.id.toString(), media.name);
    });
  }
}
