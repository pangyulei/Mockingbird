import 'package:mockingbird/app/app_state.dart';

abstract interface class AppEvents {
  AppState mainWidgetInitState();
  AppState mainWidgetBottomBarSelectedIndex(AppState state, int selectedIndex);
}
