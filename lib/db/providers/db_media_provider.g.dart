// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_media_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBMediaAsync)
final dbMediaAsyncProvider = DBMediaAsyncFamily._();

final class DBMediaAsyncProvider
    extends $AsyncNotifierProvider<DBMediaAsync, DBMedia?> {
  DBMediaAsyncProvider._({
    required DBMediaAsyncFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'dbMediaAsyncProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dBMediaAsyncHash();

  @override
  String toString() {
    return r'dbMediaAsyncProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DBMediaAsync create() => DBMediaAsync();

  @override
  bool operator ==(Object other) {
    return other is DBMediaAsyncProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dBMediaAsyncHash() => r'72d39a5a7261406fab2bbb69b05870149c096915';

final class DBMediaAsyncFamily extends $Family
    with
        $ClassFamilyOverride<
          DBMediaAsync,
          AsyncValue<DBMedia?>,
          DBMedia?,
          FutureOr<DBMedia?>,
          int
        > {
  DBMediaAsyncFamily._()
    : super(
        retry: null,
        name: r'dbMediaAsyncProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DBMediaAsyncProvider call(int id) =>
      DBMediaAsyncProvider._(argument: id, from: this);

  @override
  String toString() => r'dbMediaAsyncProvider';
}

abstract class _$DBMediaAsync extends $AsyncNotifier<DBMedia?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  FutureOr<DBMedia?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DBMedia?>, DBMedia?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DBMedia?>, DBMedia?>,
              AsyncValue<DBMedia?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
