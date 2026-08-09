// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_subtitle_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayerSubtitleList)
final playerSubtitleListProvider = PlayerSubtitleListProvider._();

final class PlayerSubtitleListProvider
    extends $NotifierProvider<PlayerSubtitleList, PlayerSubtitleListState> {
  PlayerSubtitleListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerSubtitleListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerSubtitleListHash();

  @$internal
  @override
  PlayerSubtitleList create() => PlayerSubtitleList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayerSubtitleListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayerSubtitleListState>(value),
    );
  }
}

String _$playerSubtitleListHash() =>
    r'fd4519d7587c069e3b77975ca87c2a555bc3cb48';

abstract class _$PlayerSubtitleList extends $Notifier<PlayerSubtitleListState> {
  PlayerSubtitleListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<PlayerSubtitleListState, PlayerSubtitleListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlayerSubtitleListState, PlayerSubtitleListState>,
              PlayerSubtitleListState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
