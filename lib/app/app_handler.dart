import 'package:mockingbird/app/app_events.dart';
import 'package:mockingbird/app/app_state.dart';

class AppHandler implements AppEvents {
  const AppHandler();

  @override
  AppState appWidgetBottomBarSelectedIndex(AppState state, int selectedIndex) {
    return AppState(selectedIndex);
  }

  @override
  AppState appWidgetInitState() {
    return const AppState(0);
  }
}
