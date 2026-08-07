// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_preference_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBPreference)
final dbPreferenceProvider = DBPreferenceProvider._();

final class DBPreferenceProvider
    extends $AsyncNotifierProvider<DBPreference, PreferenceEntity> {
  DBPreferenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dbPreferenceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dBPreferenceHash();

  @$internal
  @override
  DBPreference create() => DBPreference();
}

String _$dBPreferenceHash() => r'32518820f8f0de6629acdb4379a56ac02aaaea92';

abstract class _$DBPreference extends $AsyncNotifier<PreferenceEntity> {
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
