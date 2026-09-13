import 'package:collection/collection.dart';
import 'package:mockingbird/mobile/db/entities/subtitle_entity.dart';
import 'package:mockingbird/mobile/tab_player/player/mobile_player_state.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

sealed class DesktopPlayerState {
  const DesktopPlayerState();
}

class DesktopPlayerEmptyState extends DesktopPlayerState {
  const DesktopPlayerEmptyState();
}

class DesktopPlayerDataState extends DesktopPlayerState {
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

  const DesktopPlayerDataState({
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

  DesktopPlayerDataState copyWith({
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
    return DesktopPlayerDataState(
      aspectRatio: aspectRatio ?? this.aspectRatio,
      subtitleListButtonVisible: subtitleListButtonVisible ?? this.subtitleListButtonVisible,
      subtitleList: subtitleList ?? this.subtitleList,
      selectedSubtitleName: selectedSubtitleName == null
          ? this.selectedSubtitleName
          : selectedSubtitleName(),
      subtitleListVisible: subtitleListVisible ?? this.subtitleListVisible,
      loopIndex: loopIndex == null ? this.loopIndex : loopIndex(),
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

  SubtitleEntity? get selectedSubtitle {
    return subtitleList.firstWhereOrNull((s) => s.name == selectedSubtitleName);
  }
}