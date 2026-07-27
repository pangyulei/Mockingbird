// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentence_card_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SentenceCard)
final sentenceCardProvider = SentenceCardFamily._();

final class SentenceCardProvider
    extends $AsyncNotifierProvider<SentenceCard, SentenceCardState?> {
  SentenceCardProvider._({
    required SentenceCardFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'sentenceCardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sentenceCardHash();

  @override
  String toString() {
    return r'sentenceCardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SentenceCard create() => SentenceCard();

  @override
  bool operator ==(Object other) {
    return other is SentenceCardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sentenceCardHash() => r'516b95366a1335cd63833ac4a9fda29415f05835';

final class SentenceCardFamily extends $Family
    with
        $ClassFamilyOverride<
          SentenceCard,
          AsyncValue<SentenceCardState?>,
          SentenceCardState?,
          FutureOr<SentenceCardState?>,
          int?
        > {
  SentenceCardFamily._()
    : super(
        retry: null,
        name: r'sentenceCardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SentenceCardProvider call(int? id) =>
      SentenceCardProvider._(argument: id, from: this);

  @override
  String toString() => r'sentenceCardProvider';
}

abstract class _$SentenceCard extends $AsyncNotifier<SentenceCardState?> {
  late final _$args = ref.$arg as int?;
  int? get id => _$args;

  FutureOr<SentenceCardState?> build(int? id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SentenceCardState?>, SentenceCardState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SentenceCardState?>, SentenceCardState?>,
              AsyncValue<SentenceCardState?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
