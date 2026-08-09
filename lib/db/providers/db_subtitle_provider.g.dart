// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_subtitle_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DBSubtitle)
final dbSubtitleProvider = DBSubtitleFamily._();

final class DBSubtitleProvider
    extends $AsyncNotifierProvider<DBSubtitle, SubtitleEntity?> {
  DBSubtitleProvider._({
    required DBSubtitleFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'dbSubtitleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dBSubtitleHash();

  @override
  String toString() {
    return r'dbSubtitleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DBSubtitle create() => DBSubtitle();

  @override
  bool operator ==(Object other) {
    return other is DBSubtitleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dBSubtitleHash() => r'a726b30520adace8d7eff380fb8874c17be68f72';

final class DBSubtitleFamily extends $Family
    with
        $ClassFamilyOverride<
          DBSubtitle,
          AsyncValue<SubtitleEntity?>,
          SubtitleEntity?,
          FutureOr<SubtitleEntity?>,
          String?
        > {
  DBSubtitleFamily._()
    : super(
        retry: null,
        name: r'dbSubtitleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DBSubtitleProvider call(String? name) =>
      DBSubtitleProvider._(argument: name, from: this);

  @override
  String toString() => r'dbSubtitleProvider';
}

abstract class _$DBSubtitle extends $AsyncNotifier<SubtitleEntity?> {
  late final _$args = ref.$arg as String?;
  String? get name => _$args;

  FutureOr<SubtitleEntity?> build(String? name);
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
    element.handleCreate(ref, () => build(_$args));
  }
}
