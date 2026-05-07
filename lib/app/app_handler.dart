import 'package:mockingbird/app/app_events.dart';
import 'package:mockingbird/app/app_state.dart';

class AppHandler implements AppEvents {
  const AppHandler();

  @override
  AppState mainWidgetBottomBarSelectedIndex(AppState state, int selectedIndex) {
    return AppState(selectedIndex);
  }

  @override
  AppState mainWidgetInitState() {
    return const AppState(0);
  }
}
