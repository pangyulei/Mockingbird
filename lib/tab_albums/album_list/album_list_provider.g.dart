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

String _$albumListHash() => r'7ffe70ee78ca218ad0c62853d20491942f43be9f';

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
