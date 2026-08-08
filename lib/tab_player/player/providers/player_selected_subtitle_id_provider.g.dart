// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_selected_subtitle_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayerSelectedSubtitleId)
final playerSelectedSubtitleIdProvider = PlayerSelectedSubtitleIdProvider._();

final class PlayerSelectedSubtitleIdProvider
    extends $NotifierProvider<PlayerSelectedSubtitleId, String?> {
  PlayerSelectedSubtitleIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerSelectedSubtitleIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerSelectedSubtitleIdHash();

  @$internal
  @override
  PlayerSelectedSubtitleId create() => PlayerSelectedSubtitleId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$playerSelectedSubtitleIdHash() =>
    r'1a4d74ae5a25557d3c5aa842e10c6679437d9941';

abstract class _$PlayerSelectedSubtitleId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
