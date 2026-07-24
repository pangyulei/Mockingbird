// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_video_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
    r'fe9afbbd5a2f21d237fb4544db86a035ff8a9d64';

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
