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
    extends $AsyncNotifierProvider<MediaCard, MediaCardState?> {
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

  @override
  bool operator ==(Object other) {
    return other is MediaCardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mediaCardHash() => r'a169cc0a9f232e12222431c591909875161f4016';

final class MediaCardFamily extends $Family
    with
        $ClassFamilyOverride<
          MediaCard,
          AsyncValue<MediaCardState?>,
          MediaCardState?,
          FutureOr<MediaCardState?>,
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

abstract class _$MediaCard extends $AsyncNotifier<MediaCardState?> {
  late final _$args = ref.$arg as int?;
  int? get id => _$args;

  FutureOr<MediaCardState?> build(int? id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MediaCardState?>, MediaCardState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MediaCardState?>, MediaCardState?>,
              AsyncValue<MediaCardState?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
