import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_setting_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'player_setting_provider.g.dart';
const double _kMaxPlaySpeed = 3.0;
const double _kMinPlaySpeed = 0.25;
const double _kStepPlaySpeed = 0.25;

@riverpod
class PlayerSetting extends _$PlayerSetting {
  @override
  Future<PlayerSettingState> build() async {
    final prefIsLoop = await ref.read(
      dbPrefProvider.selectAsync((st) => st.isLoop),
    );
    return PlayerSettingState(
      showVolumeSlider: false,
      isLoop: prefIsLoop,
      speed: 1,
      volume: 1,
    );
  }

  Future<void> decSpeed() async {
    final currSpeed = state.value?.speed;
    if (currSpeed == null) return;
    final double nextSpeed = (currSpeed - _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    final newState = state.value?.copyWith(speed: nextSpeed);
    state = newState == null ? state : AsyncData(newState);
    // await ref.read(playerMediaProvider.notifier).updateSpeed(nextSpeed);
  }

  Future<void> incSpeed() async {
    final currSpeed = state.value?.speed;
    if (currSpeed == null) return;
    final double nextSpeed = (currSpeed + _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    final newState = state.value?.copyWith(speed: nextSpeed);
    state = newState == null ? state : AsyncData(newState);
    // await ref.read(playerMediaProvider.notifier).updateSpeed(nextSpeed);
  }

  Future<void> resetSpeed() async {
    final nextSpeed = (1.0).clamp(_kMinPlaySpeed, _kMaxPlaySpeed);
    final newData = state.value?.copyWith(speed: nextSpeed);
    state = newData == null ? state : AsyncData(newData);
    // await ref.read(playerMediaProvider.notifier).updateSpeed(nextSpeed);
  }

  Future<void> updateVolume(double newVolume) async {
    final newData = state.value?.copyWith(volume: newVolume);
    state = newData == null ? state : AsyncData(newData);
    // await ref.read(playerMediaProvider.notifier).updateVolume(newVolume);
  }

  void toggleVolume() {
    final visible = state.value?.showVolumeSlider;
    if (visible == null) return;
    final newData = state.value?.copyWith(showVolumeSlider: !visible);
    state = newData == null ? state : AsyncData(newData);
  }

  void toggleLoop() {
    final isLoop = state.value?.isLoop;
    if (isLoop == null) return;
    final newData = state.value?.copyWith(isLoop: !isLoop);
    state = newData == null ? state : AsyncData(newData);
  }
}
