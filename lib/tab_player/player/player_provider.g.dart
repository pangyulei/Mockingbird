// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Player)
final playerProvider = PlayerProvider._();

final class PlayerProvider extends $AsyncNotifierProvider<Player, PlayerState> {
  PlayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerHash();

  @$internal
  @override
  Player create() => Player();
}

String _$playerHash() => r'4e69fb1d5ba7ad8927be3fee4d41f9c03b438498';

abstract class _$Player extends $AsyncNotifier<PlayerState> {
  FutureOr<PlayerState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PlayerState>, PlayerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlayerState>, PlayerState>,
              AsyncValue<PlayerState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
