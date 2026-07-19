// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_album_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$editAlbumHash() => r'9fe4a991833e982f2aeeddf4ae5754f88e4e2fba';

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
