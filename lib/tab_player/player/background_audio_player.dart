import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockingbird/tool/event_hub.dart';
import 'package:path/path.dart' as p;

class BackgroundAudioPlayer extends BaseAudioHandler {
  final _audioPlayer = AudioPlayer();
  BackgroundAudioPlayer() {
    EventHub.on<HubAppInactiveSyncPlayerEvent>((event) async {
      await _update(event.playerInfo);
    });
  }

  Future<void> _update(PlayerInfo? playerInfo) async {
    // final path = (await media?.file)?.path;
    final mediaFile = await playerInfo?.media.file;
    final path = mediaFile?.path;
    if (playerInfo == null || path == null) {
      debugPrint('bg-audio update() missing data, clearing notification');
      _clearMediaItem();
    } else {
      final media = playerInfo.media;
      final album = p.basename(p.dirname(path));
      // Update notification UI first to satisfy system requirements immediately
      _updateMediaItemAndPlaybackState(
        item: MediaItem(
          id: media.id,
          title: await media.titleAsync,
          album: album,
          duration: playerInfo.duration,
          artUri: null, //TODO fix artUri
        ),
        playing: playerInfo.playing,
        position: playerInfo.position,
        speed: playerInfo.speed,
      );

      // Fix mediaItem not showing, audioPlayer control codes, must below updateItem
      // Then setup the audio engine
      await _audioPlayer.setAudioSource(AudioSource.file(path));
      await _audioPlayer.setVolume(playerInfo.volume);
      await _audioPlayer.seek(playerInfo.position);
      if (playerInfo.playing) {
        await _audioPlayer.play();
      } else {
        await _audioPlayer.pause();
      }
    }
  }

  void _clearMediaItem() {
    mediaItem.add(null);
  }

  void _updateMediaItemAndPlaybackState({
    required MediaItem item,
    required bool playing,
    required Duration position,
    required double speed,
  }) {
    mediaItem.add(item);
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          // MediaControl.skipToPrevious,
          // if (playing) MediaControl.pause else MediaControl.play,
          playing ? MediaControl.pause : MediaControl.play,
          // MediaControl.stop,
          // MediaControl.skipToNext,
        ],
        systemActions: const {
          // MediaAction.seek,
          MediaAction.playPause,
          // MediaAction.skipToNext,
          // MediaAction.skipToPrevious,
        },
        // androidCompactActionIndices: const [0, 1, 3],
        androidCompactActionIndices: const [0],
        processingState: AudioProcessingState.ready,
        playing: playing,
        updatePosition: position,
        speed: speed,
      ),
    );
  }

  @override
  Future<void> play() async {
    await _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
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
}
