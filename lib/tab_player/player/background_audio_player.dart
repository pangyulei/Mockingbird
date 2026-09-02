import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockingbird/tool/event_hub.dart';
import 'package:mockingbird/tool/extensions.dart';
import 'package:path/path.dart' as p;

//TODO handle loop situation

class BackgroundAudioPlayer extends BaseAudioHandler {
  final _audioPlayer = AudioPlayer();
  BackgroundAudioPlayer() {
    EventHub.on<HubSyncPlayerToBackgroundAudioEvent>(_onSyncFromPlayer);
    EventHub.on<HubAppResumeEvent>(_onAppResume);
    _audioPlayer.speedStream.listen((speed) {
      playbackState.add(playbackState.value.copyWith(speed: speed));
    });
    _audioPlayer.positionStream.listen((position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });
    _audioPlayer.playerStateStream.listen((state) {
      final playing = state.playing;
      playbackState.add(
        playbackState.value.copyWith(
          playing: playing,
          controls: [playing ? MediaControl.pause : MediaControl.play],
          processingState: switch (state.processingState) {
            ProcessingState.idle => AudioProcessingState.idle,
            ProcessingState.loading => AudioProcessingState.loading,
            ProcessingState.buffering => AudioProcessingState.buffering,
            ProcessingState.ready => AudioProcessingState.ready,
            ProcessingState.completed => AudioProcessingState.completed,
          },
        ),
      );
    });
  }

  void _onSyncFromPlayer(HubSyncPlayerToBackgroundAudioEvent event) async {
    final playerInfo = event.info;
    final mediaFile = await playerInfo?.media.file;
    final path = mediaFile?.path;
    if (playerInfo == null || path == null) return;
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
    // playbackState.add(
    //   playbackState.value.copyWith(
    //     controls: [
    //       // MediaControl.skipToPrevious,
    //       // if (playing) MediaControl.pause else MediaControl.play,
    //       playerInfo.playing ? MediaControl.pause : MediaControl.play,
    //       // MediaControl.stop,
    //       // MediaControl.skipToNext,
    //     ],
    //     systemActions: const {
    //       // MediaAction.seek,
    //       MediaAction.playPause,
    //       // MediaAction.skipToNext,
    //       // MediaAction.skipToPrevious,
    //     },
    //     // androidCompactActionIndices: const [0, 1, 3],
    //     androidCompactActionIndices: const [0],
    //     processingState: AudioProcessingState.ready,
    //     playing: playerInfo.playing,
    //     updatePosition: playerInfo.position,
    //     speed: playerInfo.speed,
    //   ),
    // );

    // Fix mediaItem not showing, audioPlayer control codes, must below updateItem
    // Then setup the audio engine
    await _audioPlayer.setAudioSource(AudioSource.file(path));
    await _audioPlayer.setVolume(playerInfo.volume);
    await _audioPlayer.seek(playerInfo.position);
    await _audioPlayer.setSpeed(playerInfo.speed);
    if (playerInfo.playing) {
      await _audioPlayer.play();
    } else {
      await _audioPlayer.pause();
    }
  }

  void _onAppResume(HubAppResumeEvent event) async {
    if (!mediaItem.hasValue) return;
    final playing = playbackState.value.playing;
    final position = playbackState.value.position;
    debugPrint(
      'Syncing back to player UI: playing=$playing, position=${position.desc}',
    );
    //remove mediaItem, stop audio player
    mediaItem.add(null);
    await _audioPlayer.stop();
    //emit event, player may start to play
    EventHub.emit(
      HubSyncBackgroundAudioToPlayerEvent(playing: playing, position: position),
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
