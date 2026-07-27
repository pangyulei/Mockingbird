// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_media_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBMedia)
final dbMediaProvider = DBMediaFamily._();

final class DBMediaProvider extends $AsyncNotifierProvider<DBMedia, EnMedia?> {
  DBMediaProvider._({
    required DBMediaFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'dbMediaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dBMediaHash();

  @override
  String toString() {
    return r'dbMediaProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DBMedia create() => DBMedia();

  @override
  bool operator ==(Object other) {
    return other is DBMediaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dBMediaHash() => r'ff9f27880ee747bc397037a72e55f68bbdfb2906';

final class DBMediaFamily extends $Family
    with
        $ClassFamilyOverride<
          DBMedia,
          AsyncValue<EnMedia?>,
          EnMedia?,
          FutureOr<EnMedia?>,
          int?
        > {
  DBMediaFamily._()
    : super(
        retry: null,
        name: r'dbMediaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DBMediaProvider call(int? id) => DBMediaProvider._(argument: id, from: this);

  @override
  String toString() => r'dbMediaProvider';
}

abstract class _$DBMedia extends $AsyncNotifier<EnMedia?> {
  late final _$args = ref.$arg as int?;
  int? get id => _$args;

  FutureOr<EnMedia?> build(int? id);
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
