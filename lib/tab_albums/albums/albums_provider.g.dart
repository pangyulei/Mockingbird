// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'albums_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Albums)
final albumsProvider = AlbumsProvider._();

final class AlbumsProvider extends $AsyncNotifierProvider<Albums, AlbumsState> {
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
}

String _$albumsHash() => r'f368876cae6ee04d13038b643cf4f75ea33b8159';

abstract class _$Albums extends $AsyncNotifier<AlbumsState> {
  FutureOr<AlbumsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AlbumsState>, AlbumsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AlbumsState>, AlbumsState>,
              AsyncValue<AlbumsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
