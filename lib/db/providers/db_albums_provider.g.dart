// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_albums_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBAlbumsAsync)
final dbAlbumsAsyncProvider = DBAlbumsAsyncProvider._();

final class DBAlbumsAsyncProvider
    extends $AsyncNotifierProvider<DBAlbumsAsync, List<DBAlbum>> {
  DBAlbumsAsyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dbAlbumsAsyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dBAlbumsAsyncHash();

  @$internal
  @override
  DBAlbumsAsync create() => DBAlbumsAsync();
}

String _$dBAlbumsAsyncHash() => r'd95fe013c190a6e0399a36a9c629cc81dcdd5b47';

abstract class _$DBAlbumsAsync extends $AsyncNotifier<List<DBAlbum>> {
  FutureOr<List<DBAlbum>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<DBAlbum>>, List<DBAlbum>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<DBAlbum>>, List<DBAlbum>>,
              AsyncValue<List<DBAlbum>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
