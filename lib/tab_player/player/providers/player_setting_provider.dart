import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_player/player/providers/player_spot_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_setting_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_setting_provider.g.dart';

const double _kMaxPlaySpeed = 3.0;
const double _kMinPlaySpeed = 0.25;
const double _kStepPlaySpeed = 0.25;

@riverpod
class PlayerSetting extends _$PlayerSetting {
  @override
  PlayerSettingState build() {
    return const PlayerSettingState(
      showVolumeSlider: false,
      speed: 1,
      volume: 1,
    );
  }

  Future<void> decSpeed() async {
    final double nextSpeed = (state.speed - _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    state = state.copyWith(speed: nextSpeed);
  }

  Future<void> incSpeed() async {
    final double nextSpeed = (state.speed + _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    state = state.copyWith(speed: nextSpeed);
  }

  Future<void> resetSpeed() async {
    final nextSpeed = (1.0).clamp(_kMinPlaySpeed, _kMaxPlaySpeed);
    state = state.copyWith(speed: nextSpeed);
  }

  Future<void> updateVolume(double newVolume) async {
    state =  state.copyWith(volume: newVolume);
  }

  void toggleVolume() {
    final visible = state.showVolumeSlider;
    state = state.copyWith(showVolumeSlider: !visible);
  }

}
