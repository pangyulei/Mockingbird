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

String _$playerSpotHash() => r'934e13c9836f2cc6a4e97deeb8f0007a050cdd8b';

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
