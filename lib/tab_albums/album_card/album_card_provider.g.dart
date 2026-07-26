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
    extends $NotifierProvider<AlbumCard, AlbumCardState> {
  AlbumCardProvider._({
    required AlbumCardFamily super.from,
    required int? super.argument,
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlbumCardState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlbumCardState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumCardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumCardHash() => r'9addc4ced0a1811cd351c2f9ad87e73226e26acd';

final class AlbumCardFamily extends $Family
    with
        $ClassFamilyOverride<
          AlbumCard,
          AlbumCardState,
          AlbumCardState,
          AlbumCardState,
          int?
        > {
  AlbumCardFamily._()
    : super(
        retry: null,
        name: r'albumCardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumCardProvider call(int? id) =>
      AlbumCardProvider._(argument: id, from: this);

  @override
  String toString() => r'albumCardProvider';
}

abstract class _$AlbumCard extends $Notifier<AlbumCardState> {
  late final _$args = ref.$arg as int?;
  int? get id => _$args;

  AlbumCardState build(int? id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AlbumCardState, AlbumCardState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AlbumCardState, AlbumCardState>,
              AlbumCardState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
