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
    extends $AsyncNotifierProvider<AlbumsAsync, List<Album>> {
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

String _$albumsAsyncHash() => r'76fc372fd965729c832b8071f88eb41be956593a';

abstract class _$AlbumsAsync extends $AsyncNotifier<List<Album>> {
  FutureOr<List<Album>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Album>>, List<Album>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Album>>, List<Album>>,
              AsyncValue<List<Album>>,
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

String _$albumsHash() => r'bfe29b17b20a2e9404cb72615e1f5264bffb1f6b';

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
