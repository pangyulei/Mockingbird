// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_media_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBMedia)
final dbMediaProvider = DBMediaFamily._();

final class DBMediaProvider
    extends $AsyncNotifierProvider<DBMedia, AssetEntity?> {
  DBMediaProvider._({
    required DBMediaFamily super.from,
    required String? super.argument,
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

String _$dBMediaHash() => r'bebddb79a975dc23c0dd0cba1c6000f70464db9f';

final class DBMediaFamily extends $Family
    with
        $ClassFamilyOverride<
          DBMedia,
          AsyncValue<AssetEntity?>,
          AssetEntity?,
          FutureOr<AssetEntity?>,
          String?
        > {
  DBMediaFamily._()
    : super(
        retry: null,
        name: r'dbMediaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DBMediaProvider call(String? id) =>
      DBMediaProvider._(argument: id, from: this);

  @override
  String toString() => r'dbMediaProvider';
}

abstract class _$DBMedia extends $AsyncNotifier<AssetEntity?> {
  late final _$args = ref.$arg as String?;
  String? get id => _$args;

  FutureOr<AssetEntity?> build(String? id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AssetEntity?>, AssetEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AssetEntity?>, AssetEntity?>,
              AsyncValue<AssetEntity?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
