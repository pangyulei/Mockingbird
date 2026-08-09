import 'package:audio_service/audio_service.dart';
import 'package:mockingbird/tab_player/player/player_media_controller.dart';

class BackgroundAudioHandler extends BaseAudioHandler {
  final PlayerMediaControllerITF _mediaController;

  BackgroundAudioHandler(this._mediaController);

  void setup({required MediaItem? item, required bool playing, required Duration position}) {
    mediaItem.add(item);
    playbackState.add(
      playbackState.value.copyWith(
        playing: playing,
        controls: [playing ? MediaControl.pause : MediaControl.play],
        updatePosition: position,
        processingState: AudioProcessingState.ready,
      ),
    );
  }

  @override
  Future<void> play() async {
    await _mediaController.play();
  }

  @override
  Future<void> pause() async {
    await _mediaController.pause();
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
    await _mediaController.seek(position);
  }
}
