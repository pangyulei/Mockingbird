// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_playing_sentence_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBPlayingSentence)
final dBPlayingSentenceProvider = DBPlayingSentenceFamily._();

final class DBPlayingSentenceProvider
    extends $AsyncNotifierProvider<DBPlayingSentence, SentenceEntity?> {
  DBPlayingSentenceProvider._({
    required DBPlayingSentenceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'dBPlayingSentenceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dBPlayingSentenceHash();

  @override
  String toString() {
    return r'dBPlayingSentenceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DBPlayingSentence create() => DBPlayingSentence();

  @override
  bool operator ==(Object other) {
    return other is DBPlayingSentenceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dBPlayingSentenceHash() => r'eb88b1ebd00041861f08c0036890b5847c9cc927';

final class DBPlayingSentenceFamily extends $Family
    with
        $ClassFamilyOverride<
          DBPlayingSentence,
          AsyncValue<SentenceEntity?>,
          SentenceEntity?,
          FutureOr<SentenceEntity?>,
          String
        > {
  DBPlayingSentenceFamily._()
    : super(
        retry: null,
        name: r'dBPlayingSentenceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DBPlayingSentenceProvider call(String id) =>
      DBPlayingSentenceProvider._(argument: id, from: this);

  @override
  String toString() => r'dBPlayingSentenceProvider';
}

abstract class _$DBPlayingSentence extends $AsyncNotifier<SentenceEntity?> {
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
