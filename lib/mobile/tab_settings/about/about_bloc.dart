import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockingbird/mobile/tab_settings/about/about_event.dart';
import 'package:mockingbird/mobile/tab_settings/about/about_state.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  AboutBloc() : super(const AboutState.empty()) {
    on<AboutInitEvent>(_onInit);
  }

  void _onInit(AboutInitEvent event, Emitter<AboutState> emit) async {
    final packageInfo = await PackageInfo.fromPlatform();
    emit(AboutState(version: packageInfo.version, appName: packageInfo.appName));
  }
}
