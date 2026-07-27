// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Player)
final playerProvider = PlayerProvider._();

final class PlayerProvider
    extends $NotifierProvider<Player, ItemScrollController> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ItemScrollController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ItemScrollController>(value),
    );
  }
}

String _$playerHash() => r'71dd00261f39999a59d8561ae38865e6ead77884';

abstract class _$Player extends $Notifier<ItemScrollController> {
  ItemScrollController build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ItemScrollController, ItemScrollController>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ItemScrollController, ItemScrollController>,
              ItemScrollController,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
