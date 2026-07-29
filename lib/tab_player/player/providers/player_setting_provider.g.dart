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
    extends $NotifierProvider<PlayerSetting, PlayerSettingState> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayerSettingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayerSettingState>(value),
    );
  }
}

String _$playerSettingHash() => r'3a364a2e2a4a986e5f9eebaadb054155efe0b69f';

abstract class _$PlayerSetting extends $Notifier<PlayerSettingState> {
  PlayerSettingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlayerSettingState, PlayerSettingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlayerSettingState, PlayerSettingState>,
              PlayerSettingState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
