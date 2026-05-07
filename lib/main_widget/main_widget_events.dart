import 'package:mockingbird/main_widget/main_widget_state.dart';

abstract interface class MainWidgetEvents {
  MainWidgetState mainWidgetInitState();
  MainWidgetState mainWidgetBottomBarSelectedIndex({
    required MainWidgetState state,
    required int selectedIndex,
  });
}
