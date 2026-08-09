// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_subtitle_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBSubtitleList)
final dbSubtitleListProvider = DBSubtitleListProvider._();

final class DBSubtitleListProvider
    extends $AsyncNotifierProvider<DBSubtitleList, List<SubtitleEntity>> {
  DBSubtitleListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dbSubtitleListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dBSubtitleListHash();

  @$internal
  @override
  DBSubtitleList create() => DBSubtitleList();
}

String _$dBSubtitleListHash() => r'0a29add1e6077d1cb35d1e116696ba8432da9a06';

abstract class _$DBSubtitleList extends $AsyncNotifier<List<SubtitleEntity>> {
  FutureOr<List<SubtitleEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<SubtitleEntity>>, List<SubtitleEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<SubtitleEntity>>,
                List<SubtitleEntity>
              >,
              AsyncValue<List<SubtitleEntity>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
