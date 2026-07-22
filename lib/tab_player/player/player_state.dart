import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

sealed class PlayerState {
  const PlayerState();
}

class PlayerNull extends PlayerState {
  const PlayerNull();
}

class PlayerData extends PlayerState {
  final String title;
  final PlayerVideoData videoData;

  const PlayerData({required this.videoData, required this.title});

  PlayerData copyWith({String? title, PlayerVideoData? videoData}) {
    return PlayerData(
      title: title ?? this.title,
      videoData: videoData ?? this.videoData,
    );
  }
}

class PlayerVideoData {
  final int sentenceCount;
  final ItemScrollController scrollController;
  final int? playingSentenceId;
  final bool showVolumeSlider;
  final VideoPlayerController controller;
  final bool isPlaying;
  final double speed;
  final double volume;
  final int positionMicro;
  final int? loopIndex;

  const PlayerVideoData({
    required this.playingSentenceId,
    required this.scrollController,
    required this.sentenceCount,
    required this.loopIndex,
    required this.positionMicro,
    required this.isPlaying,
    required this.speed,
    required this.volume,
    required this.showVolumeSlider,
    required this.controller,
  });

  bool get isLoop => loopIndex != null;

  PlayerVideoData copyWith({
    int? Function()? getPlayingSentenceId,
    int? sentenceCount,
    int? positionMicro,
    int? Function()? getLoopIndex,
    bool? isPlaying,
    double? speed,
    double? volume,
    bool? showVolumeSlider,
  }) {
    return PlayerVideoData(
      playingSentenceId: getPlayingSentenceId == null
          ? playingSentenceId
          : getPlayingSentenceId(),
      sentenceCount: sentenceCount ?? this.sentenceCount,
      scrollController: scrollController,
      loopIndex: getLoopIndex == null ? loopIndex : getLoopIndex(),
      positionMicro: positionMicro ?? this.positionMicro,
      controller: controller,
      speed: speed ?? this.speed,
      volume: volume ?? this.volume,
      isPlaying: isPlaying ?? this.isPlaying,
      showVolumeSlider: showVolumeSlider ?? this.showVolumeSlider,
    );
  }
}
