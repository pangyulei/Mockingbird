// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_album_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBAlbum)
final dbAlbumProvider = DBAlbumFamily._();

final class DBAlbumProvider extends $AsyncNotifierProvider<DBAlbum, EnAlbum?> {
  DBAlbumProvider._({
    required DBAlbumFamily super.from,
    required int super.argument,
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

String _$dBAlbumHash() => r'29dc0067a3fe147d390d4300d7457e574322389c';

final class DBAlbumFamily extends $Family
    with
        $ClassFamilyOverride<
          DBAlbum,
          AsyncValue<EnAlbum?>,
          EnAlbum?,
          FutureOr<EnAlbum?>,
          int
        > {
  DBAlbumFamily._()
    : super(
        retry: null,
        name: r'dbAlbumProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DBAlbumProvider call(int id) => DBAlbumProvider._(argument: id, from: this);

  @override
  String toString() => r'dbAlbumProvider';
}

abstract class _$DBAlbum extends $AsyncNotifier<EnAlbum?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  FutureOr<EnAlbum?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<EnAlbum?>, EnAlbum?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EnAlbum?>, EnAlbum?>,
              AsyncValue<EnAlbum?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
