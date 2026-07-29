import 'package:mockingbird/db/entities/en_sentence.dart';

class PlayerSettingState {
  final bool showVolumeSlider;
  final double speed;
  final double volume;
  const PlayerSettingState({
    required this.showVolumeSlider,
    required this.speed,
    required this.volume,
  });
  PlayerSettingState copyWith({
    double? speed,
    double? volume,
    bool? showVolumeSlider,
  }) {
    return PlayerSettingState(
      speed: speed ?? this.speed,
      volume: volume ?? this.volume,
      showVolumeSlider: showVolumeSlider ?? this.showVolumeSlider,
    );
  }
}
