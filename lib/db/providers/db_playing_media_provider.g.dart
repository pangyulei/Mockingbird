// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_playing_media_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBPlayingMedia)
final dbPlayingMediaProvider = DBPlayingMediaProvider._();

final class DBPlayingMediaProvider
    extends $AsyncNotifierProvider<DBPlayingMedia, EnMedia?> {
  DBPlayingMediaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dbPlayingMediaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dBPlayingMediaHash();

  @$internal
  @override
  DBPlayingMedia create() => DBPlayingMedia();
}

String _$dBPlayingMediaHash() => r'd6c7d11a811400be5b1f2ec28cb3dbaab76d89ae';

abstract class _$DBPlayingMedia extends $AsyncNotifier<EnMedia?> {
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
