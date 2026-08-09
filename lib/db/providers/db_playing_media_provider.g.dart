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
    extends $AsyncNotifierProvider<DBPlayingMedia, AssetEntity?> {
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

String _$dBPlayingMediaHash() => r'db6b728c0aad67378c311d54f210b9984c05e7bb';

abstract class _$DBPlayingMedia extends $AsyncNotifier<AssetEntity?> {
  FutureOr<AssetEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AssetEntity?>, AssetEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AssetEntity?>, AssetEntity?>,
              AsyncValue<AssetEntity?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
