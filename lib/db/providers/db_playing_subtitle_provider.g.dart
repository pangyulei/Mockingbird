// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_playing_subtitle_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBPlayingSubtitle)
final dbPlayingSubtitleProvider = DBPlayingSubtitleProvider._();

final class DBPlayingSubtitleProvider
    extends $AsyncNotifierProvider<DBPlayingSubtitle, SubtitleEntity?> {
  DBPlayingSubtitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dbPlayingSubtitleProvider',
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

String _$dBPlayingSubtitleHash() => r'41bc6843ddd47f09067f4f5046302e2a97a76709';

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
