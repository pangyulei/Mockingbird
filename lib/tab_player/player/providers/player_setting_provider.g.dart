// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_setting_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayerSetting)
final playerSettingProvider = PlayerSettingProvider._();

final class PlayerSettingProvider
    extends $AsyncNotifierProvider<PlayerSetting, PlayerSettingState> {
  PlayerSettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerSettingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerSettingHash();

  @$internal
  @override
  PlayerSetting create() => PlayerSetting();
}

String _$playerSettingHash() => r'93b9f3d6e0602c782ee8b47611e55b51fc2526c1';

abstract class _$PlayerSetting extends $AsyncNotifier<PlayerSettingState> {
  FutureOr<PlayerSettingState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PlayerSettingState>, PlayerSettingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlayerSettingState>, PlayerSettingState>,
              AsyncValue<PlayerSettingState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
