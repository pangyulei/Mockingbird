// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_metadata_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBMetadata)
final dbMetadataProvider = DBMetadataProvider._();

final class DBMetadataProvider
    extends $AsyncNotifierProvider<DBMetadata, MetadataEntity> {
  DBMetadataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dbMetadataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dBMetadataHash();

  @$internal
  @override
  DBMetadata create() => DBMetadata();
}

String _$dBMetadataHash() => r'bf3c37f4c14ae1e29b2a81e79f4c29fe633208e7';

abstract class _$DBMetadata extends $AsyncNotifier<MetadataEntity> {
  FutureOr<MetadataEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MetadataEntity>, MetadataEntity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MetadataEntity>, MetadataEntity>,
              AsyncValue<MetadataEntity>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
