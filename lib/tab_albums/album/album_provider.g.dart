// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Album)
final albumProvider = AlbumFamily._();

final class AlbumProvider extends $AsyncNotifierProvider<Album, AlbumState?> {
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

  @override
  bool operator ==(Object other) {
    return other is AlbumProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumHash() => r'ce418289738b424d794c1445f8948804f3e1f601';

final class AlbumFamily extends $Family
    with
        $ClassFamilyOverride<
          Album,
          AsyncValue<AlbumState?>,
          AlbumState?,
          FutureOr<AlbumState?>,
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

abstract class _$Album extends $AsyncNotifier<AlbumState?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  FutureOr<AlbumState?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AlbumState?>, AlbumState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AlbumState?>, AlbumState?>,
              AsyncValue<AlbumState?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
