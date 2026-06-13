import 'package:mockingbird/app/app_interface_ui_events.dart';
import 'package:mockingbird/app/app_state.dart';

class AppLogic implements AppInterfaceUIEvents {
  const AppLogic();

  @override
  AppState appSwitchToTab(AppState state, AppTab tab) {
    return AppState(tab);
  }

}
