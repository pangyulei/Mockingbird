// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(About)
final aboutProvider = AboutProvider._();

final class AboutProvider extends $AsyncNotifierProvider<About, AboutState> {
  AboutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aboutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aboutHash();

  @$internal
  @override
  About create() => About();
}

String _$aboutHash() => r'9ee34271dc1fec9c63636b85e1144814776595a8';

abstract class _$About extends $AsyncNotifier<AboutState> {
  FutureOr<AboutState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AboutState>, AboutState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AboutState>, AboutState>,
              AsyncValue<AboutState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
