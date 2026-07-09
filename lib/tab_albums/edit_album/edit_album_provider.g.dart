// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_album_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditAlbumAsync)
final editAlbumAsyncProvider = EditAlbumAsyncFamily._();

final class EditAlbumAsyncProvider
    extends $AsyncNotifierProvider<EditAlbumAsync, Album?> {
  EditAlbumAsyncProvider._({
    required EditAlbumAsyncFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'editAlbumAsyncProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$editAlbumAsyncHash();

  @override
  String toString() {
    return r'editAlbumAsyncProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EditAlbumAsync create() => EditAlbumAsync();

  @override
  bool operator ==(Object other) {
    return other is EditAlbumAsyncProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$editAlbumAsyncHash() => r'ed9780c4384919d9e584c6aca2de60e033f2bac8';

final class EditAlbumAsyncFamily extends $Family
    with
        $ClassFamilyOverride<
          EditAlbumAsync,
          AsyncValue<Album?>,
          Album?,
          FutureOr<Album?>,
          int?
        > {
  EditAlbumAsyncFamily._()
    : super(
        retry: null,
        name: r'editAlbumAsyncProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EditAlbumAsyncProvider call(int? id) =>
      EditAlbumAsyncProvider._(argument: id, from: this);

  @override
  String toString() => r'editAlbumAsyncProvider';
}

abstract class _$EditAlbumAsync extends $AsyncNotifier<Album?> {
  late final _$args = ref.$arg as int?;
  int? get id => _$args;

  FutureOr<Album?> build(int? id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Album?>, Album?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Album?>, Album?>,
              AsyncValue<Album?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(EditAlbum)
final editAlbumProvider = EditAlbumFamily._();

final class EditAlbumProvider
    extends $NotifierProvider<EditAlbum, EditAlbumState> {
  EditAlbumProvider._({
    required EditAlbumFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'editAlbumProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$editAlbumHash();

  @override
  String toString() {
    return r'editAlbumProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EditAlbum create() => EditAlbum();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EditAlbumState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EditAlbumState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EditAlbumProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$editAlbumHash() => r'bd20e3b4b32f31a8777c9afa623f3e887c0666c4';

final class EditAlbumFamily extends $Family
    with
        $ClassFamilyOverride<
          EditAlbum,
          EditAlbumState,
          EditAlbumState,
          EditAlbumState,
          int?
        > {
  EditAlbumFamily._()
    : super(
        retry: null,
        name: r'editAlbumProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EditAlbumProvider call(int? id) =>
      EditAlbumProvider._(argument: id, from: this);

  @override
  String toString() => r'editAlbumProvider';
}

abstract class _$EditAlbum extends $Notifier<EditAlbumState> {
  late final _$args = ref.$arg as int?;
  int? get id => _$args;

  EditAlbumState build(int? id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EditAlbumState, EditAlbumState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EditAlbumState, EditAlbumState>,
              EditAlbumState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
