import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_state.dart';
import 'package:mockingbird/app/app_ui.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> implements AppUIOutputITF {

  @override
  Widget build(BuildContext context) {
    return AppUI(this);
  }

  @override
  void app_selectedTab(AppTab tab, StatefulNavigationShell shell) {
    // ➔ 切换 Tab 的核心方法
    shell.goBranch(
      tab.raw,
      initialLocation:
        tab.raw == shell.currentIndex, // 重复点击当前 Tab 会回到该 Tab 的根路由
    );
  }
}
