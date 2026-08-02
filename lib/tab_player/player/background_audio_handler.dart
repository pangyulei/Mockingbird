import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:mockingbird/tab_player/player/providers/player_media_controller.dart';

class BackgroundAudioHandler extends BaseAudioHandler {
  final PlayerMediaControllerITF _mediaController;

  BackgroundAudioHandler(this._mediaController) {
    // Initial State
    // mediaItem.add(
    //   const MediaItem(
    //     id: 'mockingbird_loading',
    //     title: 'Mockingbird',
    //     album: 'Mockingbird',

    //   ),
    // );

    // playbackState.add(
    //   PlaybackState(
    //     controls: [MediaControl.play],
    //     androidCompactActionIndices: const [0],
    //     processingState: AudioProcessingState.ready,
    //     playing: _mediaController.mb_isPlaying,
    //     updatePosition: _mediaController.mb_position,
    //   ),
    // );

    // Listeners
    _mediaController.mb_listenPlaying((mediaController, isPlaying) {
      debugPrint('BackgroundAudioHandler: isPlaying changed to $isPlaying');
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

    _mediaController.mb_listenDuration((mediaController, duration) {
      mediaItem.add(mediaItem.value?.copyWith(duration: duration));
    });

    _mediaController.mb_listenBuffering((mediaController, isBuffering) {
      playbackState.add(
        playbackState.value.copyWith(
          processingState: isBuffering
              ? AudioProcessingState.buffering
              : AudioProcessingState.ready,
        ),
      );
    });
  }

  void mb_updateMediaItem(MediaItem item) {
    mediaItem.add(item);
  }

  @override
  Future<void> play() async {
    await _mediaController.mb_play();
  }

  @override
  Future<void> pause() async {
    await _mediaController.mb_pause();
  }

  // @override
  // Future<void> stop() async {
  //   await _mediaController.mb_pause();
  //   playbackState.add(
  //     playbackState.value.copyWith(
  //       playing: false,
  //       processingState: AudioProcessingState.idle,
  //     ),
  //   );
  //   await super.stop();
  // }

  @override
  Future<void> seek(Duration position) async {
    await _mediaController.mb_seek(position);
  }
}
