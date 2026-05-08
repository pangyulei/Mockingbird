import 'package:mockingbird/app/app_state.dart';

abstract interface class AppEvents {
  AppState appWidgetInitState();
  AppState appWidgetBottomBarSelectedIndex(AppState state, int selectedIndex);
}
