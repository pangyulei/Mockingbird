// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_name_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayerTitle)
final playerTitleProvider = PlayerTitleProvider._();

final class PlayerTitleProvider extends $NotifierProvider<PlayerTitle, String> {
  PlayerTitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerTitleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerTitleHash();

  @$internal
  @override
  PlayerTitle create() => PlayerTitle();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$playerTitleHash() => r'd665b31856c1afd173e9f20e99bf7836928896f8';

abstract class _$PlayerTitle extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
