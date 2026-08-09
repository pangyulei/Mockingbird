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
    extends $NotifierProvider<SentenceCard, SentenceCardState> {
  SentenceCardProvider._({
    required SentenceCardFamily super.from,
    required String super.argument,
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SentenceCardState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SentenceCardState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SentenceCardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sentenceCardHash() => r'd6c20a7f361ef23d463ec3405649563d404abd58';

final class SentenceCardFamily extends $Family
    with
        $ClassFamilyOverride<
          SentenceCard,
          SentenceCardState,
          SentenceCardState,
          SentenceCardState,
          String
        > {
  SentenceCardFamily._()
    : super(
        retry: null,
        name: r'sentenceCardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SentenceCardProvider call(String id) =>
      SentenceCardProvider._(argument: id, from: this);

  @override
  String toString() => r'sentenceCardProvider';
}

abstract class _$SentenceCard extends $Notifier<SentenceCardState> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  SentenceCardState build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SentenceCardState, SentenceCardState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SentenceCardState, SentenceCardState>,
              SentenceCardState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
