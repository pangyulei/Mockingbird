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
    extends $AsyncNotifierProvider<DBAlbumsAsync, List<Album>> {
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

String _$dBAlbumsAsyncHash() => r'b114b1531e640b7e94e0e6297a466d55c2a492c6';

abstract class _$DBAlbumsAsync extends $AsyncNotifier<List<Album>> {
  FutureOr<List<Album>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Album>>, List<Album>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Album>>, List<Album>>,
              AsyncValue<List<Album>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
