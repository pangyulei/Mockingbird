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
    extends $AsyncNotifierProvider<DBSentence, EnSentence?> {
  DBSentenceProvider._({
    required DBSentenceFamily super.from,
    required int? super.argument,
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

String _$dBSentenceHash() => r'816c1888ea9523e8cfad2454fc1a0e300da9026d';

final class DBSentenceFamily extends $Family
    with
        $ClassFamilyOverride<
          DBSentence,
          AsyncValue<EnSentence?>,
          EnSentence?,
          FutureOr<EnSentence?>,
          int?
        > {
  DBSentenceFamily._()
    : super(
        retry: null,
        name: r'dbSentenceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DBSentenceProvider call(int? id) =>
      DBSentenceProvider._(argument: id, from: this);

  @override
  String toString() => r'dbSentenceProvider';
}

abstract class _$DBSentence extends $AsyncNotifier<EnSentence?> {
  late final _$args = ref.$arg as int?;
  int? get id => _$args;

  FutureOr<EnSentence?> build(int? id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<EnSentence?>, EnSentence?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EnSentence?>, EnSentence?>,
              AsyncValue<EnSentence?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
