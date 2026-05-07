import 'package:flutter/material.dart';

class MainWidgetState {
  final int bottomBarSelectedIndex;
  final Widget bodyWidget;

  const MainWidgetState({
    required this.bottomBarSelectedIndex,
    required this.bodyWidget,
  });
}
