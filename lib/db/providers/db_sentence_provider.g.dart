// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_sentence_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBSentence)
final dbSentenceProvider = DBSentenceFamily._();

final class DBSentenceProvider
    extends $AsyncNotifierProvider<DBSentence, SentenceEntity?> {
  DBSentenceProvider._({
    required DBSentenceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'dbSentenceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dBSentenceHash();

  @override
  String toString() {
    return r'dbSentenceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DBSentence create() => DBSentence();

  @override
  bool operator ==(Object other) {
    return other is DBSentenceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dBSentenceHash() => r'2cf8ecf7498c97f142db0f3bd793a09e560a7fcd';

final class DBSentenceFamily extends $Family
    with
        $ClassFamilyOverride<
          DBSentence,
          AsyncValue<SentenceEntity?>,
          SentenceEntity?,
          FutureOr<SentenceEntity?>,
          String
        > {
  DBSentenceFamily._()
    : super(
        retry: null,
        name: r'dbSentenceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DBSentenceProvider call(String id) =>
      DBSentenceProvider._(argument: id, from: this);

  @override
  String toString() => r'dbSentenceProvider';
}

abstract class _$DBSentence extends $AsyncNotifier<SentenceEntity?> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<SentenceEntity?> build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SentenceEntity?>, SentenceEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SentenceEntity?>, SentenceEntity?>,
              AsyncValue<SentenceEntity?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
