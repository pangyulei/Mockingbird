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
    extends $AsyncNotifierProvider<EditAlbumAsync, DBAlbum?> {
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

String _$editAlbumAsyncHash() => r'deadee347be29569700455a37b25cbd1e0818c29';

final class EditAlbumAsyncFamily extends $Family
    with
        $ClassFamilyOverride<
          EditAlbumAsync,
          AsyncValue<DBAlbum?>,
          DBAlbum?,
          FutureOr<DBAlbum?>,
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

abstract class _$EditAlbumAsync extends $AsyncNotifier<DBAlbum?> {
  late final _$args = ref.$arg as int?;
  int? get id => _$args;

  FutureOr<DBAlbum?> build(int? id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DBAlbum?>, DBAlbum?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DBAlbum?>, DBAlbum?>,
              AsyncValue<DBAlbum?>,
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

String _$editAlbumHash() => r'34f7cd75364b88dcdc6fd64188250b74c9e706d4';

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
