import 'package:flutter/material.dart';
import 'package:mockingbird/main_widget/main_widget_events.dart';
import 'package:mockingbird/main_widget/main_widget_state.dart';

class MainWidgetHandler implements MainWidgetEvents {
  const MainWidgetHandler();

  @override
  MainWidgetState mainWidgetBottomBarSelectedIndex({
    required MainWidgetState state,
    required int selectedIndex,
  }) {
    return MainWidgetState(
      bottomBarSelectedIndex: selectedIndex,
      bodyWidget: Center(child: Text('Index $selectedIndex Widget')),
    );
  }

  @override
  MainWidgetState mainWidgetInitState() {
    return const MainWidgetState(
      bottomBarSelectedIndex: 0,
      bodyWidget: Center(child: Text('Index 0 Widget')),
    );
  }
}
