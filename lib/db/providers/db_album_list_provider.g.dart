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
    extends $AsyncNotifierProvider<DBAlbumList, List<EnAlbum>> {
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

String _$dBAlbumListHash() => r'5d59f0cc53a125b2dcd800696d9b0b9a423892f0';

abstract class _$DBAlbumList extends $AsyncNotifier<List<EnAlbum>> {
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
