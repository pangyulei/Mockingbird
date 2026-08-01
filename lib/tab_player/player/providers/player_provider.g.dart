// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Player)
final playerProvider = PlayerFamily._();

final class PlayerProvider extends $NotifierProvider<Player, void> {
  PlayerProvider._({
    required PlayerFamily super.from,
    required ItemScrollController super.argument,
  }) : super(
         retry: null,
         name: r'playerProvider',
         isAutoDispose: true,
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playerHash() => r'f32ccb0319f61ede2bd297b710e3eae273a9e901';

final class PlayerFamily extends $Family
    with $ClassFamilyOverride<Player, void, void, void, ItemScrollController> {
  PlayerFamily._()
    : super(
        retry: null,
        name: r'playerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlayerProvider call(ItemScrollController scrollController) =>
      PlayerProvider._(argument: scrollController, from: this);

  @override
  String toString() => r'playerProvider';
}

abstract class _$Player extends $Notifier<void> {
  late final _$args = ref.$arg as ItemScrollController;
  ItemScrollController get scrollController => _$args;

  void build(ItemScrollController scrollController);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
