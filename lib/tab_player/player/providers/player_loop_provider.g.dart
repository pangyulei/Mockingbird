// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_loop_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayerLoop)
final playerLoopProvider = PlayerLoopProvider._();

final class PlayerLoopProvider
    extends $AsyncNotifierProvider<PlayerLoop, PlayerLoopState> {
  PlayerLoopProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerLoopProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerLoopHash();

  @$internal
  @override
  PlayerLoop create() => PlayerLoop();
}

String _$playerLoopHash() => r'dea2ac51397edde554d80b8be1658944c311d98a';

abstract class _$PlayerLoop extends $AsyncNotifier<PlayerLoopState> {
  FutureOr<PlayerLoopState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PlayerLoopState>, PlayerLoopState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlayerLoopState>, PlayerLoopState>,
              AsyncValue<PlayerLoopState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
