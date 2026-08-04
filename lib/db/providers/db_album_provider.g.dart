// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_album_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBFolder)
final dbAlbumProvider = DBFolderFamily._();

final class DBFolderProvider
    extends $AsyncNotifierProvider<DBFolder, AssetPathEntity?> {
  DBFolderProvider._({
    required DBFolderFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'dbAlbumProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dBFolderHash();

  @override
  String toString() {
    return r'dbAlbumProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DBFolder create() => DBFolder();

  @override
  bool operator ==(Object other) {
    return other is DBFolderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dBFolderHash() => r'704a2c4ab8ff7f1f38f1dfce3be6c5fd6b7a0451';

final class DBFolderFamily extends $Family
    with
        $ClassFamilyOverride<
          DBFolder,
          AsyncValue<AssetPathEntity?>,
          AssetPathEntity?,
          FutureOr<AssetPathEntity?>,
          String
        > {
  DBFolderFamily._()
    : super(
        retry: null,
        name: r'dbAlbumProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DBFolderProvider call(String id) =>
      DBFolderProvider._(argument: id, from: this);

  @override
  String toString() => r'dbAlbumProvider';
}

abstract class _$DBFolder extends $AsyncNotifier<AssetPathEntity?> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<AssetPathEntity?> build(String id);
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
