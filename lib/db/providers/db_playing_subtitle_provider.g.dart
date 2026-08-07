// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_playing_subtitle_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBPlayingSubtitle)
final dbSubtitleProvider = DBPlayingSubtitleProvider._();

final class DBPlayingSubtitleProvider
    extends $AsyncNotifierProvider<DBPlayingSubtitle, SubtitleEntity?> {
  DBPlayingSubtitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dbSubtitleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dBPlayingSubtitleHash();

  @$internal
  @override
  DBPlayingSubtitle create() => DBPlayingSubtitle();
}

String _$dBPlayingSubtitleHash() => r'3896ade4c5036af047631864f1e1394bc89f8cfe';

abstract class _$DBPlayingSubtitle extends $AsyncNotifier<SubtitleEntity?> {
  FutureOr<SubtitleEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SubtitleEntity?>, SubtitleEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SubtitleEntity?>, SubtitleEntity?>,
              AsyncValue<SubtitleEntity?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
