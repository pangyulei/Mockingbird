import 'package:mockingbird/tab_settings/about/about_state.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'about_provider.g.dart';

@riverpod
class About extends _$About {
  @override
  Future<AboutState> build() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return AboutState(
      version: packageInfo.version,
      appName: packageInfo.appName,
      buildNumber: packageInfo.buildNumber,
    );
  }
}
