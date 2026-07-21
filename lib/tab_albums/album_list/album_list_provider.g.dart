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
    extends $NotifierProvider<AlbumList, AlbumListState> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlbumListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlbumListState>(value),
    );
  }
}

String _$albumListHash() => r'a55140233068118c7a54d4568a61eeaa4f508661';

abstract class _$AlbumList extends $Notifier<AlbumListState> {
  AlbumListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AlbumListState, AlbumListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AlbumListState, AlbumListState>,
              AlbumListState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
