// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Player)
final playerProvider = PlayerProvider._();

final class PlayerProvider extends $NotifierProvider<Player, PlayerState?> {
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
  Override overrideWithValue(PlayerState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayerState?>(value),
    );
  }
}

String _$playerHash() => r'2f2023af9ff72783297ed93d4a6075686aa1921a';

abstract class _$Player extends $Notifier<PlayerState?> {
  PlayerState? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlayerState?, PlayerState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlayerState?, PlayerState?>,
              PlayerState?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(PlayerVideo)
final playerVideoProvider = PlayerVideoProvider._();

final class PlayerVideoProvider
    extends $NotifierProvider<PlayerVideo, PlayerVideoState?> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayerVideoState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayerVideoState?>(value),
    );
  }
}

String _$playerVideoHash() => r'0fb9bfe6a3ab43a78486850674f02ee0c1775616';

abstract class _$PlayerVideo extends $Notifier<PlayerVideoState?> {
  PlayerVideoState? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlayerVideoState?, PlayerVideoState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlayerVideoState?, PlayerVideoState?>,
              PlayerVideoState?,
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
    r'2d44af38cdbc8cc5803d415969c2f327879517ac';

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

@ProviderFor(PlayerMedia)
final playerMediaProvider = PlayerMediaProvider._();

final class PlayerMediaProvider
    extends $NotifierProvider<PlayerMedia, EnMedia?> {
  PlayerMediaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerMediaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerMediaHash();

  @$internal
  @override
  PlayerMedia create() => PlayerMedia();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EnMedia? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EnMedia?>(value),
    );
  }
}

String _$playerMediaHash() => r'4e67274d3da5a04b414b532880f4ffd189231ca6';

abstract class _$PlayerMedia extends $Notifier<EnMedia?> {
  EnMedia? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EnMedia?, EnMedia?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EnMedia?, EnMedia?>,
              EnMedia?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
