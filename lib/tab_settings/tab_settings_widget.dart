import 'package:flutter/material.dart';

class TabSettingWidget extends StatefulWidget {
  const TabSettingWidget({super.key});

  @override
  State<TabSettingWidget> createState() => _TabSettingWidgetFactory();
}

class _TabSettingWidgetFactory extends State<TabSettingWidget> {
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
