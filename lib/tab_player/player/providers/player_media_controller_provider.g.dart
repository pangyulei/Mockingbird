// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_media_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayerVideoController)
final playerVideoControllerProvider = PlayerVideoControllerProvider._();

final class PlayerVideoControllerProvider
    extends
        $AsyncNotifierProvider<
          PlayerVideoController,
          PlayerMediaControllerITF?
        > {
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
    r'96f684242224a80c098fd0c94f0ee30f4f274718';

abstract class _$PlayerVideoController
    extends $AsyncNotifier<PlayerMediaControllerITF?> {
  FutureOr<PlayerMediaControllerITF?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PlayerMediaControllerITF?>,
              PlayerMediaControllerITF?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PlayerMediaControllerITF?>,
                PlayerMediaControllerITF?
              >,
              AsyncValue<PlayerMediaControllerITF?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
