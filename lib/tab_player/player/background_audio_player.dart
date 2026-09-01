import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockingbird/tab_player/player/player_bloc.dart';
import 'package:mockingbird/tab_player/player/player_state.dart';
import 'package:mockingbird/tool/event_hub.dart';
import 'package:path/path.dart' as p;

import '../../tool/extensions.dart';

class BackgroundAudioPlayer extends BaseAudioHandler {
  final _audioPlayer = AudioPlayer();
  BackgroundAudioPlayer() {
    EventHub.on<HubAppInactiveEvent>((event) async {
      await _update();
    });
  }

  Future<void> _update() async {
    final playerBloc = SharedPlayerBloc.instance;
    final playerState = playerBloc.state.as<PlayerDataState>();
    final media = playerBloc.media;
    final path = (await media?.file)?.path;

    if (path == null || media == null || playerState == null) {
      debugPrint('bg-audio update() missing data, clearing notification');
      _updateMediaItemAndPlaybackState();
    } else {
      final album = p.basename(p.dirname(path));
      final playerValue = playerState.player.value;
      final playing = playerValue.isPlaying;
      final position = playerValue.position;

      // Update notification UI first to satisfy system requirements immediately
      _updateMediaItemAndPlaybackState(
        item: MediaItem(
          id: media.id,
          title: playerState.title,
          album: album,
          duration: playerValue.duration,
          artUri: null, //TODO fix artUri
        ),
        playing: playing,
        position: position,
        speed: playerValue.playbackSpeed,
      );

      // Fix mediaItem not showing, audioPlayer control codes, must below updateItem
      // Then setup the audio engine
      await _audioPlayer.setAudioSource(AudioSource.file(path));
      await _audioPlayer.setVolume(playerValue.volume);
      await _audioPlayer.seek(position);
      if (playing) {
        await _audioPlayer.play();
      } else {
        await _audioPlayer.pause();
      }
    }
  }

  void _updateMediaItemAndPlaybackState({
    MediaItem? item,
    bool playing = false,
    Duration position = const Duration(seconds: 0),
    double speed = 1.0,
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
