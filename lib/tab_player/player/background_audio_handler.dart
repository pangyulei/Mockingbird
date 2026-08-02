import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_controller.dart';

class BackgroundAudioHandler extends BaseAudioHandler {
  final PlayerMediaControllerITF _mediaController;
  BackgroundAudioHandler(this._mediaController) {
    _mediaController.mb_listenPlaying((mediaController, isPlaying) {
      debugPrint('bg isplaying $isPlaying');
      playbackState.add(
        playbackState.value.copyWith(
          playing: isPlaying,
          controls: [isPlaying ? MediaControl.pause : MediaControl.play],
        ),
      );
    });
    _mediaController.mb_listenPosition((mediaController, position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });
  }

  void updateMedia(String id, String title) {
    mediaItem.add(MediaItem(id: id, title: title));
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
