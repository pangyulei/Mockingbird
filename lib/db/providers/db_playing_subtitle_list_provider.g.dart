// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_playing_subtitle_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBPlayingSubtitleList)
final dbPlayingSubtitleListProvider = DBPlayingSubtitleListProvider._();

final class DBPlayingSubtitleListProvider
    extends
        $AsyncNotifierProvider<DBPlayingSubtitleList, List<SubtitleEntity>> {
  DBPlayingSubtitleListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dbPlayingSubtitleListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dBPlayingSubtitleListHash();

  @$internal
  @override
  DBPlayingSubtitleList create() => DBPlayingSubtitleList();
}

String _$dBPlayingSubtitleListHash() =>
    r'bb7dafae882cdfcbb9e2dbc4b3d520477581b304';

abstract class _$DBPlayingSubtitleList
    extends $AsyncNotifier<List<SubtitleEntity>> {
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
