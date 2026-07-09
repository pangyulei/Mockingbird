// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlbumAsync)
final albumAsyncProvider = AlbumAsyncFamily._();

final class AlbumAsyncProvider
    extends $AsyncNotifierProvider<AlbumAsync, DBAlbum?> {
  AlbumAsyncProvider._({
    required AlbumAsyncFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'albumAsyncProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumAsyncHash();

  @override
  String toString() {
    return r'albumAsyncProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AlbumAsync create() => AlbumAsync();

  @override
  bool operator ==(Object other) {
    return other is AlbumAsyncProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumAsyncHash() => r'cd9f8f3143ffda7cdc4ee40ba1484130d6c7e6c4';

final class AlbumAsyncFamily extends $Family
    with
        $ClassFamilyOverride<
          AlbumAsync,
          AsyncValue<DBAlbum?>,
          DBAlbum?,
          FutureOr<DBAlbum?>,
          int
        > {
  AlbumAsyncFamily._()
    : super(
        retry: null,
        name: r'albumAsyncProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumAsyncProvider call(int id) =>
      AlbumAsyncProvider._(argument: id, from: this);

  @override
  String toString() => r'albumAsyncProvider';
}

abstract class _$AlbumAsync extends $AsyncNotifier<DBAlbum?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  FutureOr<DBAlbum?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DBAlbum?>, DBAlbum?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DBAlbum?>, DBAlbum?>,
              AsyncValue<DBAlbum?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(Album)
final albumProvider = AlbumFamily._();

final class AlbumProvider extends $NotifierProvider<Album, AlbumState?> {
  AlbumProvider._({
    required AlbumFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'albumProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumHash();

  @override
  String toString() {
    return r'albumProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Album create() => Album();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlbumState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlbumState?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumHash() => r'f4a959f8485414b3d9b3bd9d6329f0e7e43ec30e';

final class AlbumFamily extends $Family
    with
        $ClassFamilyOverride<
          Album,
          AlbumState?,
          AlbumState?,
          AlbumState?,
          int
        > {
  AlbumFamily._()
    : super(
        retry: null,
        name: r'albumProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumProvider call(int id) => AlbumProvider._(argument: id, from: this);

  @override
  String toString() => r'albumProvider';
}

abstract class _$Album extends $Notifier<AlbumState?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  AlbumState? build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AlbumState?, AlbumState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AlbumState?, AlbumState?>,
              AlbumState?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
