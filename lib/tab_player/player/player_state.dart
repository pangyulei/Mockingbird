import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

class PlayerVideoState {
  final bool loop;
  final int? loopingIndex;
  final bool showVolumeSlider;
  final VideoPlayerController controller;
  final bool isPlaying;
  final double speed;
  final double volume;
  final int positionMicro;

  const PlayerVideoState({
    required this.loop,
    required this.positionMicro,
    required this.isPlaying,
    required this.speed,
    required this.volume,
    required this.loopingIndex,
    required this.showVolumeSlider,
    required this.controller,
  });

  PlayerVideoState copyWith({
    bool? loop,
    int? positionMicro,
    int? Function()? loopingIndex,
    bool? isPlaying,
    double? speed,
    double? volume,
    bool? showVolumeSlider,
  }) {
    return PlayerVideoState(
      loop: loop ?? this.loop,
      positionMicro: positionMicro ?? this.positionMicro,
      controller: controller,
      speed: speed ?? this.speed,
      volume: volume ?? this.volume,
      loopingIndex: loopingIndex == null ? this.loopingIndex : loopingIndex(),
      isPlaying: isPlaying ?? this.isPlaying,
      showVolumeSlider: showVolumeSlider ?? this.showVolumeSlider,
    );
  }
}

class PlayerState {
  final String title;
  final int sentenceCount;
  final ItemScrollController scrollController;
  final PlayerVideoState? videoState;
  final int? playingSentenceId;

  const PlayerState({
    required this.playingSentenceId,
    required this.scrollController,
    required this.videoState,
    required this.title,
    required this.sentenceCount,
  });

  PlayerState copyWith({
    int? Function()? playingSentenceId,
    String? title,
    int? sentenceCount,
    PlayerVideoState? Function()? videoState,
  }) {
    return PlayerState(
      playingSentenceId: playingSentenceId == null
          ? this.playingSentenceId
          : playingSentenceId(),
      title: title ?? this.title,
      sentenceCount: sentenceCount ?? this.sentenceCount,
      videoState: videoState == null ? this.videoState : videoState(),
      scrollController: scrollController,
    );
  }
}
