import 'package:flutter/material.dart';

abstract interface class PlayerNavInterfaceUIEvents {
  Route<dynamic>? playerNavOnGenerateRoute(RouteSettings settings);
  List<Route<dynamic>> playerNavOnGenerateInitialRoute(
    NavigatorState navigator,
    String initialRoute,
  );
}
