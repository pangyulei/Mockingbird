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
    extends $NotifierProvider<PlayerSubtitle, PlayerSubtitleState> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayerSubtitleState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayerSubtitleState>(value),
    );
  }
}

String _$playerSubtitleHash() => r'50ab84dd9c05a4e0927cbfd9f8d4115a1300584c';

abstract class _$PlayerSubtitle extends $Notifier<PlayerSubtitleState> {
  PlayerSubtitleState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlayerSubtitleState, PlayerSubtitleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlayerSubtitleState, PlayerSubtitleState>,
              PlayerSubtitleState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
