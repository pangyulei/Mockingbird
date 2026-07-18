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

String _$playerHash() => r'63f496bb5067ed9f2af7f53430e0dde0b1661d16';

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
final playerVideoProvider = PlayerVideoFamily._();

final class PlayerVideoProvider
    extends $NotifierProvider<PlayerVideo, PlayerVideoState?> {
  PlayerVideoProvider._({
    required PlayerVideoFamily super.from,
    required void Function(VideoPlayerController) super.argument,
  }) : super(
         retry: null,
         name: r'playerVideoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playerVideoHash();

  @override
  String toString() {
    return r'playerVideoProvider'
        ''
        '($argument)';
  }

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

  @override
  bool operator ==(Object other) {
    return other is PlayerVideoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playerVideoHash() => r'6d0af0951de2366181fea51f003cd5e0fbfee1a6';

final class PlayerVideoFamily extends $Family
    with
        $ClassFamilyOverride<
          PlayerVideo,
          PlayerVideoState?,
          PlayerVideoState?,
          PlayerVideoState?,
          void Function(VideoPlayerController)
        > {
  PlayerVideoFamily._()
    : super(
        retry: null,
        name: r'playerVideoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlayerVideoProvider call(void Function(VideoPlayerController) listener) =>
      PlayerVideoProvider._(argument: listener, from: this);

  @override
  String toString() => r'playerVideoProvider';
}

abstract class _$PlayerVideo extends $Notifier<PlayerVideoState?> {
  late final _$args = ref.$arg as void Function(VideoPlayerController);
  void Function(VideoPlayerController) get listener => _$args;

  PlayerVideoState? build(void Function(VideoPlayerController) listener);
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
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(PlayerVideoController)
final playerVideoControllerProvider = PlayerVideoControllerFamily._();

final class PlayerVideoControllerProvider
    extends
        $AsyncNotifierProvider<PlayerVideoController, VideoPlayerController?> {
  PlayerVideoControllerProvider._({
    required PlayerVideoControllerFamily super.from,
    required void Function(VideoPlayerController) super.argument,
  }) : super(
         retry: null,
         name: r'playerVideoControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playerVideoControllerHash();

  @override
  String toString() {
    return r'playerVideoControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PlayerVideoController create() => PlayerVideoController();

  @override
  bool operator ==(Object other) {
    return other is PlayerVideoControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playerVideoControllerHash() =>
    r'071da721fb44e4129ad3bc90a6536d789dca6c19';

final class PlayerVideoControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PlayerVideoController,
          AsyncValue<VideoPlayerController?>,
          VideoPlayerController?,
          FutureOr<VideoPlayerController?>,
          void Function(VideoPlayerController)
        > {
  PlayerVideoControllerFamily._()
    : super(
        retry: null,
        name: r'playerVideoControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlayerVideoControllerProvider call(
    void Function(VideoPlayerController) listener,
  ) => PlayerVideoControllerProvider._(argument: listener, from: this);

  @override
  String toString() => r'playerVideoControllerProvider';
}

abstract class _$PlayerVideoController
    extends $AsyncNotifier<VideoPlayerController?> {
  late final _$args = ref.$arg as void Function(VideoPlayerController);
  void Function(VideoPlayerController) get listener => _$args;

  FutureOr<VideoPlayerController?> build(
    void Function(VideoPlayerController) listener,
  );
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
    element.handleCreate(ref, () => build(_$args));
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
