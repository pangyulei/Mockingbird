// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_playing_media_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayingMedia)
final playingMediaProvider = PlayingMediaProvider._();

final class PlayingMediaProvider
    extends $AsyncNotifierProvider<PlayingMedia, EnMedia?> {
  PlayingMediaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playingMediaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playingMediaHash();

  @$internal
  @override
  PlayingMedia create() => PlayingMedia();
}

String _$playingMediaHash() => r'56ab05625ab2498a8a25b3e6ef4430f18f0c6a4e';

abstract class _$PlayingMedia extends $AsyncNotifier<EnMedia?> {
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
