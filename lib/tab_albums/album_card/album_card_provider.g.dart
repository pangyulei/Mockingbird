// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_card_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlbumCard)
final albumCardProvider = AlbumCardFamily._();

final class AlbumCardProvider
    extends $AsyncNotifierProvider<AlbumCard, AlbumCardState?> {
  AlbumCardProvider._({
    required AlbumCardFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'albumCardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumCardHash();

  @override
  String toString() {
    return r'albumCardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AlbumCard create() => AlbumCard();

  @override
  bool operator ==(Object other) {
    return other is AlbumCardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumCardHash() => r'9aff81bbeae8b2e36be3140fc8b9de918950020c';

final class AlbumCardFamily extends $Family
    with
        $ClassFamilyOverride<
          AlbumCard,
          AsyncValue<AlbumCardState?>,
          AlbumCardState?,
          FutureOr<AlbumCardState?>,
          int
        > {
  AlbumCardFamily._()
    : super(
        retry: null,
        name: r'albumCardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumCardProvider call(int id) =>
      AlbumCardProvider._(argument: id, from: this);

  @override
  String toString() => r'albumCardProvider';
}

abstract class _$AlbumCard extends $AsyncNotifier<AlbumCardState?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  FutureOr<AlbumCardState?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AlbumCardState?>, AlbumCardState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AlbumCardState?>, AlbumCardState?>,
              AsyncValue<AlbumCardState?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
