import 'package:mockingbird/app/app_state.dart';

abstract interface class AppInterfaceUIEvents {
  AppState appSwitchToTab(AppState state, AppTab tab);
}
