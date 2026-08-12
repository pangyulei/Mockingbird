// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_album_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBAlbum)
final dbAlbumProvider = DBAlbumFamily._();

final class DBAlbumProvider
    extends $AsyncNotifierProvider<DBAlbum, AssetPathEntity?> {
  DBAlbumProvider._({
    required DBAlbumFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'dbAlbumProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dBAlbumHash();

  @override
  String toString() {
    return r'dbAlbumProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DBAlbum create() => DBAlbum();

  @override
  bool operator ==(Object other) {
    return other is DBAlbumProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dBAlbumHash() => r'8d8acd0060037a6f0532d624b5ee393413a5f478';

final class DBAlbumFamily extends $Family
    with
        $ClassFamilyOverride<
          DBAlbum,
          AsyncValue<AssetPathEntity?>,
          AssetPathEntity?,
          FutureOr<AssetPathEntity?>,
          String?
        > {
  DBAlbumFamily._()
    : super(
        retry: null,
        name: r'dbAlbumProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DBAlbumProvider call(String? id) =>
      DBAlbumProvider._(argument: id, from: this);

  @override
  String toString() => r'dbAlbumProvider';
}

abstract class _$DBAlbum extends $AsyncNotifier<AssetPathEntity?> {
  late final _$args = ref.$arg as String?;
  String? get id => _$args;

  FutureOr<AssetPathEntity?> build(String? id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<AssetPathEntity?>, AssetPathEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AssetPathEntity?>, AssetPathEntity?>,
              AsyncValue<AssetPathEntity?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
