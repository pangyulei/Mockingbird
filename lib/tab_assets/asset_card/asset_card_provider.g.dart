// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_card_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AssetCard)
final assetCardProvider = AssetCardFamily._();

final class AssetCardProvider
    extends $AsyncNotifierProvider<AssetCard, AssetCardState?> {
  AssetCardProvider._({
    required AssetCardFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'assetCardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assetCardHash();

  @override
  String toString() {
    return r'assetCardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AssetCard create() => AssetCard();

  @override
  bool operator ==(Object other) {
    return other is AssetCardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetCardHash() => r'de295373b33d264d6495df82122403a48cf3b006';

final class AssetCardFamily extends $Family
    with
        $ClassFamilyOverride<
          AssetCard,
          AsyncValue<AssetCardState?>,
          AssetCardState?,
          FutureOr<AssetCardState?>,
          String
        > {
  AssetCardFamily._()
    : super(
        retry: null,
        name: r'assetCardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AssetCardProvider call(String id) =>
      AssetCardProvider._(argument: id, from: this);

  @override
  String toString() => r'assetCardProvider';
}

abstract class _$AssetCard extends $AsyncNotifier<AssetCardState?> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<AssetCardState?> build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AssetCardState?>, AssetCardState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AssetCardState?>, AssetCardState?>,
              AsyncValue<AssetCardState?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
