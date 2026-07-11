// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Player)
final playerProvider = PlayerFamily._();

final class PlayerProvider
    extends $AsyncNotifierProvider<Player, PlayerState?> {
  PlayerProvider._({
    required PlayerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'playerProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playerHash();

  @override
  String toString() {
    return r'playerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Player create() => Player();

  @override
  bool operator ==(Object other) {
    return other is PlayerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playerHash() => r'578dc70f0cda205e9fb8d43ee8ae8403bb7ed422';

final class PlayerFamily extends $Family
    with
        $ClassFamilyOverride<
          Player,
          AsyncValue<PlayerState?>,
          PlayerState?,
          FutureOr<PlayerState?>,
          int
        > {
  PlayerFamily._()
    : super(
        retry: null,
        name: r'playerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  PlayerProvider call(int id) => PlayerProvider._(argument: id, from: this);

  @override
  String toString() => r'playerProvider';
}

abstract class _$Player extends $AsyncNotifier<PlayerState?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  FutureOr<PlayerState?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PlayerState?>, PlayerState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlayerState?>, PlayerState?>,
              AsyncValue<PlayerState?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
