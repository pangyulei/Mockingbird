// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_pref_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBPref)
final dbPrefProvider = DBPrefProvider._();

final class DBPrefProvider
    extends $AsyncNotifierProvider<DBPref, PreferenceEntity> {
  DBPrefProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dbPrefProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dBPrefHash();

  @$internal
  @override
  DBPref create() => DBPref();
}

String _$dBPrefHash() => r'938ff1902b59470a46afe93fdb38befd636e9588';

abstract class _$DBPref extends $AsyncNotifier<PreferenceEntity> {
  FutureOr<PreferenceEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PreferenceEntity>, PreferenceEntity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PreferenceEntity>, PreferenceEntity>,
              AsyncValue<PreferenceEntity>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
