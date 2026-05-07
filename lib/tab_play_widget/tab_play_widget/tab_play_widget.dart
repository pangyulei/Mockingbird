import 'package:flutter/material.dart';

class TabPlayWidget extends StatefulWidget {
  const TabPlayWidget({super.key});

  @override
  State<TabPlayWidget> createState() => _TabPlayWidgetFactory();
}

class _TabPlayWidgetFactory extends State<TabPlayWidget> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return null;
      },
      onGenerateInitialRoutes: (navigator, initialRoute) {
        return [];
      },
    );
  }
}
