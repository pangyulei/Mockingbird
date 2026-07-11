// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_albums_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBAlbums)
final dbAlbumsProvider = DBAlbumsProvider._();

final class DBAlbumsProvider
    extends $AsyncNotifierProvider<DBAlbums, List<EnAlbum>> {
  DBAlbumsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dbAlbumsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dBAlbumsHash();

  @$internal
  @override
  DBAlbums create() => DBAlbums();
}

String _$dBAlbumsHash() => r'1cb236f224f9a06f2aed2cf5b65d08581d4d225d';

abstract class _$DBAlbums extends $AsyncNotifier<List<EnAlbum>> {
  FutureOr<List<EnAlbum>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<EnAlbum>>, List<EnAlbum>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<EnAlbum>>, List<EnAlbum>>,
              AsyncValue<List<EnAlbum>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
