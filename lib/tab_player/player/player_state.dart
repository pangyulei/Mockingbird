import 'package:mockingbird/db/entities/sentence_entity.dart';
import 'package:photo_manager/photo_manager.dart';

sealed class PlayerState {
  final bool loading;
  const PlayerState({this.loading = false});
  PlayerState copyWith({bool? loading});
}

class PlayerInitState extends PlayerState {
  const PlayerInitState() : super(loading: true);
  @override
  PlayerInitState copyWith({bool? loading}) {
    return this;
  }
}

class PlayerEmptyState extends PlayerState {
  const PlayerEmptyState({super.loading});

  @override
  PlayerEmptyState copyWith({bool? loading}) {
    return PlayerEmptyState(loading: loading ?? this.loading);
  }
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
  const PlayerDataState({
    super.loading,
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

  @override
  PlayerDataState copyWith({
    int? Function()? loopIndex,
    bool? playing,
    bool? loading,
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
      loading: loading ?? this.loading,
      subtitle: subtitle ?? this.subtitle,
      showVolumeSlider: showVolumeSlider ?? this.showVolumeSlider,
      volume: volume ?? this.volume,
      speed: speed ?? this.speed,
      position: position ?? this.position,
      duration: duration ?? this.duration,
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
