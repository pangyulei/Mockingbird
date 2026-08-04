// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_album_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBAlbumList)
final dbAlbumListProvider = DBAlbumListProvider._();

final class DBAlbumListProvider
    extends $AsyncNotifierProvider<DBAlbumList, List<AssetPathEntity>> {
  DBAlbumListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dbAlbumListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dBAlbumListHash();

  @$internal
  @override
  DBAlbumList create() => DBAlbumList();
}

String _$dBAlbumListHash() => r'dbba8b1e374c19f28fdf7a67e32c2c8c300479a7';

abstract class _$DBAlbumList extends $AsyncNotifier<List<AssetPathEntity>> {
  FutureOr<List<AssetPathEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<AssetPathEntity>>, List<AssetPathEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AssetPathEntity>>,
                List<AssetPathEntity>
              >,
              AsyncValue<List<AssetPathEntity>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
