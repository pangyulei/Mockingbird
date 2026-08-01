import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_controller.dart';

class BackgroundAudioHandler extends BaseAudioHandler {
  final PlayerMediaControllerITF _mediaController;
  BackgroundAudioHandler(this._mediaController) {
    playbackState.add(
      PlaybackState(
        controls: [MediaControl.play, MediaControl.pause],
        androidCompactActionIndices: const [0, 1],
      ),
    );
    _mediaController.mb_listenPlaying((mediaController, isPlaying) {
      debugPrint('bg isplaying $isPlaying');
      playbackState.add(playbackState.value.copyWith(playing: isPlaying));
    });
    _mediaController.mb_listenPosition((mediaController, position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });
  }
  @override
  Future<void> play() async {
    await _mediaController.mb_play();
  }

  @override
  Future<void> pause() async {
    await _mediaController.mb_pause();
  }

  @override
  Future<void> seek(Duration position) async {
    await _mediaController.mb_seek(position);
  }
}
