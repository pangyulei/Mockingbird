import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockingbird/tool/event_hub.dart';
import 'package:path/path.dart' as p;

//TODO handle loop situation

class BackgroundAudioPlayer extends BaseAudioHandler {
  final _audioPlayer = AudioPlayer();
  BackgroundAudioPlayer() {
    EventHub.on<HubSyncPlayerToBackgroundAudioEvent>((event) async {
      await _syncFromPlayer(event.info);
    });
    EventHub.on<HubAppResumeEvent>(_syncToPlayer);
  }

  void _syncToPlayer(HubAppResumeEvent event) {
    if (mediaItem.valueOrNull == null) return;
    EventHub.emit(
      HubSyncBackgroundAudioToPlayerEvent(
        BackgroundAudioInfo(
          playing: _audioPlayer.playing,
          position: _audioPlayer.position,
        ),
      ),
    );
  }

  Future<void> _syncFromPlayer(PlayerMediaInfo? playerInfo) async {
    // final path = (await media?.file)?.path;
    final mediaFile = await playerInfo?.media.file;
    final path = mediaFile?.path;
    if (playerInfo == null || path == null) {
      debugPrint('bg-audio update() missing data, clearing notification');
      mediaItem.add(null);
      playbackState.add(
        playbackState.value.copyWith(
          controls: const [],
          systemActions: const {},
          androidCompactActionIndices: null,
          processingState: AudioProcessingState.idle,
          playing: false,
          updatePosition: const Duration(seconds: 0),
          speed: 1,
        ),
      );
      await _audioPlayer.clearAudioSources();
    } else {
      final media = playerInfo.media;
      final album = p.basename(p.dirname(path));
      // Update notification UI first to satisfy system requirements immediately
      mediaItem.add(
        MediaItem(
          id: media.id,
          title: await media.titleAsync,
          album: album,
          duration: playerInfo.duration,
          artUri: null, //TODO fix artUri
        ),
      );
      playbackState.add(
        playbackState.value.copyWith(
          controls: [
            // MediaControl.skipToPrevious,
            // if (playing) MediaControl.pause else MediaControl.play,
            playerInfo.playing ? MediaControl.pause : MediaControl.play,
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
          playing: playerInfo.playing,
          updatePosition: playerInfo.position,
          speed: playerInfo.speed,
        ),
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

  @override
  Future<void> play() async {
    playbackState.add(
      playbackState.value.copyWith(
        controls: [MediaControl.pause],
        playing: true,
      ),
    );
    await _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    playbackState.add(
      playbackState.value.copyWith(
        controls: [MediaControl.play],
        playing: false,
      ),
    );
    await _audioPlayer.pause();
  }

  @override
  Future<void> seek(Duration position) async {
    playbackState.add(playbackState.value.copyWith(updatePosition: position));
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
