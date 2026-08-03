// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_spot_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayerSpot)
final playerSpotProvider = PlayerSpotProvider._();

final class PlayerSpotProvider
    extends $AsyncNotifierProvider<PlayerSpot, PlayerSpotState?> {
  PlayerSpotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerSpotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerSpotHash();

  @$internal
  @override
  PlayerSpot create() => PlayerSpot();
}

String _$playerSpotHash() => r'b40a46095124065436f6007fdbb8e81e289ea0a6';

abstract class _$PlayerSpot extends $AsyncNotifier<PlayerSpotState?> {
  FutureOr<PlayerSpotState?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PlayerSpotState?>, PlayerSpotState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlayerSpotState?>, PlayerSpotState?>,
              AsyncValue<PlayerSpotState?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
