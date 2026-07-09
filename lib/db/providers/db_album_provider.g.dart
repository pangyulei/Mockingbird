// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_album_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBAlbumAsync)
final dbAlbumAsyncProvider = DBAlbumAsyncFamily._();

final class DBAlbumAsyncProvider
    extends $AsyncNotifierProvider<DBAlbumAsync, Album?> {
  DBAlbumAsyncProvider._({
    required DBAlbumAsyncFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'dbAlbumAsyncProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dBAlbumAsyncHash();

  @override
  String toString() {
    return r'dbAlbumAsyncProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DBAlbumAsync create() => DBAlbumAsync();

  @override
  bool operator ==(Object other) {
    return other is DBAlbumAsyncProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dBAlbumAsyncHash() => r'b051d2a5cd13e1985964d09f296a0be0ef6105e2';

final class DBAlbumAsyncFamily extends $Family
    with
        $ClassFamilyOverride<
          DBAlbumAsync,
          AsyncValue<Album?>,
          Album?,
          FutureOr<Album?>,
          int
        > {
  DBAlbumAsyncFamily._()
    : super(
        retry: null,
        name: r'dbAlbumAsyncProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DBAlbumAsyncProvider call(int id) =>
      DBAlbumAsyncProvider._(argument: id, from: this);

  @override
  String toString() => r'dbAlbumAsyncProvider';
}

abstract class _$DBAlbumAsync extends $AsyncNotifier<Album?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  FutureOr<Album?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Album?>, Album?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Album?>, Album?>,
              AsyncValue<Album?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
