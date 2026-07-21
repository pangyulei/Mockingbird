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
    extends $NotifierProvider<Player, UIStateNullable<PlayerState>> {
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
  Override overrideWithValue(UIStateNullable<PlayerState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UIStateNullable<PlayerState>>(value),
    );
  }
}

String _$playerHash() => r'2202c0be6218776ca7f0f0f6b21e964eb3d5c212';

abstract class _$Player extends $Notifier<UIStateNullable<PlayerState>> {
  UIStateNullable<PlayerState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<UIStateNullable<PlayerState>, UIStateNullable<PlayerState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                UIStateNullable<PlayerState>,
                UIStateNullable<PlayerState>
              >,
              UIStateNullable<PlayerState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(PlayerVideo)
final playerVideoProvider = PlayerVideoProvider._();

final class PlayerVideoProvider
    extends $AsyncNotifierProvider<PlayerVideo, PlayerVideoState?> {
  PlayerVideoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerVideoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerVideoHash();

  @$internal
  @override
  PlayerVideo create() => PlayerVideo();
}

String _$playerVideoHash() => r'e37c1f067077c42404e02a404ebf6809814d5f89';

abstract class _$PlayerVideo extends $AsyncNotifier<PlayerVideoState?> {
  FutureOr<PlayerVideoState?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PlayerVideoState?>, PlayerVideoState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlayerVideoState?>, PlayerVideoState?>,
              AsyncValue<PlayerVideoState?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(PlayerVideoController)
final playerVideoControllerProvider = PlayerVideoControllerProvider._();

final class PlayerVideoControllerProvider
    extends
        $AsyncNotifierProvider<PlayerVideoController, VideoPlayerController?> {
  PlayerVideoControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerVideoControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerVideoControllerHash();

  @$internal
  @override
  PlayerVideoController create() => PlayerVideoController();
}

String _$playerVideoControllerHash() =>
    r'7c013047548c54b0c01e7ddba822e458a1559d8b';

abstract class _$PlayerVideoController
    extends $AsyncNotifier<VideoPlayerController?> {
  FutureOr<VideoPlayerController?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<VideoPlayerController?>, VideoPlayerController?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<VideoPlayerController?>,
                VideoPlayerController?
              >,
              AsyncValue<VideoPlayerController?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
