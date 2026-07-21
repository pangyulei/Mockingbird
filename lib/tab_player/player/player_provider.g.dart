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
    extends $AsyncNotifierProvider<Player, PlayerState?> {
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

String _$playerHash() => r'2e48dcf8df95705ad765ec3142780b80adee9138';

abstract class _$Player extends $AsyncNotifier<PlayerState?> {
  FutureOr<PlayerState?> build();
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

String _$playerVideoHash() => r'38d6ccba82a9a4b84c175bf2429af30abeddaaa3';

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
    r'438eab93663c911c14e587f55161a36cc91a7543';

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
    extends $AsyncNotifierProvider<PlayerMedia, EnMedia?> {
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
}

String _$playerMediaHash() => r'2500c1e218d9ed15eed8d3bb16a18d850b80520f';

abstract class _$PlayerMedia extends $AsyncNotifier<EnMedia?> {
  FutureOr<EnMedia?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<EnMedia?>, EnMedia?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EnMedia?>, EnMedia?>,
              AsyncValue<EnMedia?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
