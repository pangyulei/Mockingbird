// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'albums_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlbumsAsync)
final albumsAsyncProvider = AlbumsAsyncProvider._();

final class AlbumsAsyncProvider
    extends $AsyncNotifierProvider<AlbumsAsync, List<DBAlbum>> {
  AlbumsAsyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'albumsAsyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$albumsAsyncHash();

  @$internal
  @override
  AlbumsAsync create() => AlbumsAsync();
}

String _$albumsAsyncHash() => r'c1d512629dd0e200d15cb212162083581810629b';

abstract class _$AlbumsAsync extends $AsyncNotifier<List<DBAlbum>> {
  FutureOr<List<DBAlbum>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<DBAlbum>>, List<DBAlbum>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<DBAlbum>>, List<DBAlbum>>,
              AsyncValue<List<DBAlbum>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(Albums)
final albumsProvider = AlbumsProvider._();

final class AlbumsProvider extends $NotifierProvider<Albums, AlbumsState> {
  AlbumsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'albumsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$albumsHash();

  @$internal
  @override
  Albums create() => Albums();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlbumsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlbumsState>(value),
    );
  }
}

String _$albumsHash() => r'6685a0ee40f5b588c0e19b676d74c35095e5828d';

abstract class _$Albums extends $Notifier<AlbumsState> {
  AlbumsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AlbumsState, AlbumsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AlbumsState, AlbumsState>,
              AlbumsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
