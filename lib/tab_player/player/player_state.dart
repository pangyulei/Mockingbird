import 'package:collection/collection.dart';
import 'package:mockingbird/db/entities/sentence_entity.dart';
import 'package:mockingbird/db/entities/subtitle_entity.dart';
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
  final double aspectRatio;
  final bool volumeSliderVisible;
  final AssetType mediaType;
  final bool subtitleListVisible;
  final String? selectedSubtitleName;
  final List<SubtitleEntity> subtitleList;
  final PlayerSubtitleState subtitleState;
  final VideoPlayerController player;
  final ItemScrollController scroller;
  final bool subtitleListButtonVisible;

  const PlayerDataState({
    required this.aspectRatio,
    required this.subtitleListButtonVisible,
    required this.subtitleList,
    required this.selectedSubtitleName,
    required this.subtitleListVisible,
    required this.scroller,
    required this.player,
    required this.volumeSliderVisible,
    required this.loopIndex,
    required this.playing,
    required this.subtitleState,
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
    double? aspectRatio,
    double? volume,
    double? speed,
    PlayerSubtitleState? subtitleState,
    AssetType? mediaType,
    bool? volumeSliderVisible,
    bool? subtitleListVisible,
    bool? subtitleListButtonVisible,
    String? Function()? selectedSubtitleName,
    Duration? position,
    Duration? duration,
    String? title,
    List<SubtitleEntity>? subtitleList,
  }) {
    return PlayerDataState(
      aspectRatio: aspectRatio ?? this.aspectRatio,
      subtitleListButtonVisible: subtitleListButtonVisible ?? this.subtitleListButtonVisible,
      subtitleList: subtitleList ?? this.subtitleList,
      selectedSubtitleName: selectedSubtitleName?.call() ?? this.selectedSubtitleName,
      subtitleListVisible: subtitleListVisible ?? this.subtitleListVisible,
      loopIndex: loopIndex?.call() ?? this.loopIndex,
      playing: playing ?? this.playing,
      title: title ?? this.title,
      mediaType: mediaType ?? this.mediaType,
      subtitleState: subtitleState ?? this.subtitleState,
      volumeSliderVisible: volumeSliderVisible ?? this.volumeSliderVisible,
      volume: volume ?? this.volume,
      speed: speed ?? this.speed,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      player: player,
      scroller: scroller,
    );
  }

  SubtitleEntity? get subtitle {
    return subtitleList.firstWhereOrNull((s) => s.name == selectedSubtitleName);
  }
}

sealed class PlayerSubtitleState {
  const PlayerSubtitleState();
}

class PlayerSubtitleEmptyState extends PlayerSubtitleState {
  const PlayerSubtitleEmptyState();
}

class PlayerSubtitleDataState extends PlayerSubtitleState {
  final List<SentenceEntity> sentenceList;
  final double initialAlignment;
  final int initialIndex;

  const PlayerSubtitleDataState({required this.sentenceList, required this.initialAlignment, required this.initialIndex});
}
