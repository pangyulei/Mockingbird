// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlbumList)
final albumListProvider = AlbumListProvider._();

final class AlbumListProvider
    extends $AsyncNotifierProvider<AlbumList, AlbumListState> {
  AlbumListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'albumListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$albumListHash();

  @$internal
  @override
  AlbumList create() => AlbumList();
}

String _$albumListHash() => r'1545430fb7185d1c568c1ca41a6c7699d87a7870';

abstract class _$AlbumList extends $AsyncNotifier<AlbumListState> {
  FutureOr<AlbumListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AlbumListState>, AlbumListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AlbumListState>, AlbumListState>,
              AsyncValue<AlbumListState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
