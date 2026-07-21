// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_media_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditMedia)
final editMediaProvider = EditMediaFamily._();

final class EditMediaProvider
    extends $NotifierProvider<EditMedia, EditMediaState> {
  EditMediaProvider._({
    required EditMediaFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'editMediaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$editMediaHash();

  @override
  String toString() {
    return r'editMediaProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EditMedia create() => EditMedia();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EditMediaState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EditMediaState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EditMediaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$editMediaHash() => r'0c09b307ca40d0a980bbbb598723cee1c223f4e3';

final class EditMediaFamily extends $Family
    with
        $ClassFamilyOverride<
          EditMedia,
          EditMediaState,
          EditMediaState,
          EditMediaState,
          int?
        > {
  EditMediaFamily._()
    : super(
        retry: null,
        name: r'editMediaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EditMediaProvider call(int? id) =>
      EditMediaProvider._(argument: id, from: this);

  @override
  String toString() => r'editMediaProvider';
}

abstract class _$EditMedia extends $Notifier<EditMediaState> {
  late final _$args = ref.$arg as int?;
  int? get id => _$args;

  EditMediaState build(int? id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EditMediaState, EditMediaState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EditMediaState, EditMediaState>,
              EditMediaState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
