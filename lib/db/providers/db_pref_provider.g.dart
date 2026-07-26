// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_pref_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBPref)
final dbPrefProvider = DBPrefProvider._();

final class DBPrefProvider extends $AsyncNotifierProvider<DBPref, EnPref> {
  DBPrefProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dbPrefProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dBPrefHash();

  @$internal
  @override
  DBPref create() => DBPref();
}

String _$dBPrefHash() => r'2693a7a91c02ff01faf588a86159b75d89a5acad';

abstract class _$DBPref extends $AsyncNotifier<EnPref> {
  FutureOr<EnPref> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<EnPref>, EnPref>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EnPref>, EnPref>,
              AsyncValue<EnPref>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
