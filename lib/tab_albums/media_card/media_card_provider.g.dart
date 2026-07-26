// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_card_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MediaCard)
final mediaCardProvider = MediaCardFamily._();

final class MediaCardProvider
    extends $NotifierProvider<MediaCard, MediaCardState> {
  MediaCardProvider._({
    required MediaCardFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'mediaCardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mediaCardHash();

  @override
  String toString() {
    return r'mediaCardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MediaCard create() => MediaCard();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaCardState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaCardState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MediaCardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mediaCardHash() => r'04492d3bafb723e1149f16e2aa909c77a740eb4b';

final class MediaCardFamily extends $Family
    with
        $ClassFamilyOverride<
          MediaCard,
          MediaCardState,
          MediaCardState,
          MediaCardState,
          int?
        > {
  MediaCardFamily._()
    : super(
        retry: null,
        name: r'mediaCardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MediaCardProvider call(int? id) =>
      MediaCardProvider._(argument: id, from: this);

  @override
  String toString() => r'mediaCardProvider';
}

abstract class _$MediaCard extends $Notifier<MediaCardState> {
  late final _$args = ref.$arg as int?;
  int? get id => _$args;

  MediaCardState build(int? id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MediaCardState, MediaCardState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MediaCardState, MediaCardState>,
              MediaCardState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
