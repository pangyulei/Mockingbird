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
    extends $AsyncNotifierProvider<DBMediaAsync, EnMedia?> {
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

String _$dBMediaAsyncHash() => r'9c9139bdec94f3a31da68c2f90543c3339d22113';

final class DBMediaAsyncFamily extends $Family
    with
        $ClassFamilyOverride<
          DBMediaAsync,
          AsyncValue<EnMedia?>,
          EnMedia?,
          FutureOr<EnMedia?>,
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

abstract class _$DBMediaAsync extends $AsyncNotifier<EnMedia?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  FutureOr<EnMedia?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<EnMedia?>, EnMedia?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EnMedia?>, EnMedia?>,
              AsyncValue<EnMedia?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
