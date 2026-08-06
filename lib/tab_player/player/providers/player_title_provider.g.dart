// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_title_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayerTitle)
final playerTitleProvider = PlayerTitleProvider._();

final class PlayerTitleProvider
    extends $AsyncNotifierProvider<PlayerTitle, String?> {
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
}

String _$playerTitleHash() => r'43aca5dcd18d57953f8aeef80ef148e302e63cd2';

abstract class _$PlayerTitle extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
