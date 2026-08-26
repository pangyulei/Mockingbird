import 'package:mockingbird/db/entities/sentence_entity.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

sealed class PlayerState {
  const PlayerState();
}

class PlayerInitState extends PlayerState {
  const PlayerInitState();
}

class PlayerEmptyState extends PlayerState {
  const PlayerEmptyState();
}

class PlayerDataState extends PlayerState {
  final int? loopIndex;
  final bool playing;
  final String title;
  final Duration position;
  final Duration duration;
  final double volume;
  final double speed;
  final bool showVolumeSlider;
  final AssetType mediaType;
  final PlayerSubtitleState subtitle;
  final VideoPlayerController player;
  final ItemScrollController scroller;
  const PlayerDataState({
    required this.scroller,
    required this.player,
    required this.showVolumeSlider,
    required this.loopIndex,
    required this.playing,
    required this.subtitle,
    required this.position,
    required this.duration,
    required this.volume,
    required this.speed,
    required this.mediaType,
    required this.title,
  });

  PlayerDataState copyWith({
    int? Function()? loopIndex,
    bool? playing,
    double? volume,
    double? speed,
    PlayerSubtitleState? subtitle,
    AssetType? mediaType,
    bool? showVolumeSlider,
    Duration? position,
    Duration? duration,
    String? title,
  }) {
    return PlayerDataState(
      loopIndex: loopIndex == null ? this.loopIndex : loopIndex(),
      playing: playing ?? this.playing,
      title: title ?? this.title,
      mediaType: mediaType ?? this.mediaType,
      subtitle: subtitle ?? this.subtitle,
      showVolumeSlider: showVolumeSlider ?? this.showVolumeSlider,
      volume: volume ?? this.volume,
      speed: speed ?? this.speed,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      player: player,
      scroller: scroller,
    );
  }
}

sealed class PlayerSubtitleState {
  const PlayerSubtitleState();
}

class PlayerSubtitleEmptyState extends PlayerSubtitleState {
  const PlayerSubtitleEmptyState();
}

class PlayerSubtitleDataState extends PlayerSubtitleState {
  // final List<String> subtitleNameList;
  // final String subtitleName;
  final List<SentenceEntity> sentenceList;
  const PlayerSubtitleDataState({required this.sentenceList});
}
