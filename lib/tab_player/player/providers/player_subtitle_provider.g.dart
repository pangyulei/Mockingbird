// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_subtitle_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayerSubtitle)
final playerSubtitleProvider = PlayerSubtitleProvider._();

final class PlayerSubtitleProvider
    extends $AsyncNotifierProvider<PlayerSubtitle, PlayerSubtitleState> {
  PlayerSubtitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerSubtitleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerSubtitleHash();

  @$internal
  @override
  PlayerSubtitle create() => PlayerSubtitle();
}

String _$playerSubtitleHash() => r'11c1032e8fa4f150d58a0b3ed05f7148b3e24419';

abstract class _$PlayerSubtitle extends $AsyncNotifier<PlayerSubtitleState> {
  FutureOr<PlayerSubtitleState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PlayerSubtitleState>, PlayerSubtitleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlayerSubtitleState>, PlayerSubtitleState>,
              AsyncValue<PlayerSubtitleState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
