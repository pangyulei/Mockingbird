class PlayerSetting {
  final bool showVolumeSlider;
  final bool isLoop;
  final double speed;
  final double volume;
  const PlayerSetting({
    required this.showVolumeSlider,
    required this.isLoop,
    required this.speed,
    required this.volume,
  });
  PlayerSetting copyWith({
    bool? isLoop,
    double? speed,
    double? volume,
    bool? showVolumeSlider,
  }) {
    return PlayerSetting(
      isLoop: isLoop ?? this.isLoop,
      speed: speed ?? this.speed,
      volume: volume ?? this.volume,
      showVolumeSlider: showVolumeSlider ?? this.showVolumeSlider,
    );
  }
}
