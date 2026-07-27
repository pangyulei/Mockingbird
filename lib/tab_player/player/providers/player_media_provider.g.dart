// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_media_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayerMedia)
final playerMediaProvider = PlayerMediaProvider._();

final class PlayerMediaProvider
    extends $AsyncNotifierProvider<PlayerMedia, PlayerMediaState> {
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

String _$playerMediaHash() => r'04946fa2c48e28302fd7a5095c113f513a28ba6f';

abstract class _$PlayerMedia extends $AsyncNotifier<PlayerMediaState> {
  FutureOr<PlayerMediaState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PlayerMediaState>, PlayerMediaState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlayerMediaState>, PlayerMediaState>,
              AsyncValue<PlayerMediaState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
