// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlbumDetail)
final albumDetailProvider = AlbumDetailFamily._();

final class AlbumDetailProvider
    extends $NotifierProvider<AlbumDetail, AlbumDetailState> {
  AlbumDetailProvider._({
    required AlbumDetailFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'albumDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumDetailHash();

  @override
  String toString() {
    return r'albumDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AlbumDetail create() => AlbumDetail();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlbumDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlbumDetailState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumDetailHash() => r'd6cc130638f9c8d99204e40eb883684a8f071a02';

final class AlbumDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          AlbumDetail,
          AlbumDetailState,
          AlbumDetailState,
          AlbumDetailState,
          int?
        > {
  AlbumDetailFamily._()
    : super(
        retry: null,
        name: r'albumDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumDetailProvider call(int? id) =>
      AlbumDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'albumDetailProvider';
}

abstract class _$AlbumDetail extends $Notifier<AlbumDetailState> {
  late final _$args = ref.$arg as int?;
  int? get id => _$args;

  AlbumDetailState build(int? id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AlbumDetailState, AlbumDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AlbumDetailState, AlbumDetailState>,
              AlbumDetailState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
