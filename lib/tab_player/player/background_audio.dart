import 'package:audio_service/audio_service.dart';
import 'package:mockingbird/db/db.dart';
import 'package:mockingbird/tool/event_hub.dart';
import 'package:path/path.dart' as p;
import 'package:photo_manager/photo_manager.dart';

class SharedBackgroundAudio {
  static final audio = BackgroundAudio();
}

class BackgroundAudio extends BaseAudioHandler {
  BackgroundAudio() {
  }
  void update() async {
    final mediaId = (await DB.loadMetadata()).playingMediaId;
    if (mediaId == null) return;
    final media = await AssetEntity.fromId(mediaId);
    if (media == null) {
      _load(item: null, playing: false, position: const Duration(seconds: 0));
    } else {
      final path = (await media.file)?.path ?? '';
      final album = p.basename(p.dirname(path));
      _load(
        item: MediaItem(
          id: media.id,
          title: await media.titleAsync,
          album: album,
          duration: media.videoDuration,
          artUri: null, //TODO fix artUri
        ),
        playing: false,//TODO
        position: const Duration(seconds: 0),
      );
    }
  }

  void _load({
    required MediaItem? item,
    required bool playing,
    required Duration position,
  }) {
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
    // await SharedPlayer.player.play();
  }

  @override
  Future<void> pause() async {
    // await SharedPlayer.player.pause();
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
    // await SharedPlayer.player.seek(position);
  }
}
