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
  final List<int> sentenceIdList;
  final bool showVolumeSlider;
  final VideoPlayerController videoController;
  final bool isPlaying;
  final double speed;
  final double volume;
  final int positionMicro;
  final int? loopIndex;
  final ItemScrollController scrollController;
  final int? playingSentenceId;

  const PlayerVideoData({
    required this.sentenceIdList,
    required this.playingSentenceId,
    required this.scrollController,
    required this.loopIndex,
    required this.positionMicro,
    required this.isPlaying,
    required this.speed,
    required this.volume,
    required this.showVolumeSlider,
    required this.videoController,
  });

  bool get isLoop => loopIndex != null;

  PlayerVideoData copyWith({
    int? positionMicro,
    int? Function()? loopIndex,
    int? Function()? playingSentenceId,
    bool? isPlaying,
    double? speed,
    double? volume,
    bool? showVolumeSlider,
    List<int>? sentenceIdList,
  }) {
    return PlayerVideoData(
      sentenceIdList: sentenceIdList ?? this.sentenceIdList,
      loopIndex: loopIndex == null ? this.loopIndex : loopIndex(),
      positionMicro: positionMicro ?? this.positionMicro,
      videoController: videoController,
      speed: speed ?? this.speed,
      volume: volume ?? this.volume,
      isPlaying: isPlaying ?? this.isPlaying,
      showVolumeSlider: showVolumeSlider ?? this.showVolumeSlider,
      playingSentenceId: playingSentenceId == null
          ? this.playingSentenceId
          : playingSentenceId(),
      scrollController: scrollController,
    );
  }
}
