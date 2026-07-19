import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingbird/app/app_route.dart';

class AppUI extends StatelessWidget {
  const AppUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoute((index, shell) {
        // ➔ 切换 Tab 的核心方法
        shell.goBranch(
          index,
          initialLocation: index == shell.currentIndex, // 重复点击当前 Tab 会回到该 Tab 的根路由
        );
      }).router,
      theme: _theme(),
      builder: EasyLoading.init(),
      // builder: (context, child) => _home(),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: _theme(),
    //   home: _home(),
    // );
  }

  ThemeData _theme() {
    const background = Color(0xFF0E1621);
    const surface = Color(0xFF17212B);
    const primary = Color(0xFF5288C1);
    const textPrimary = Colors.white;
    const textSecondary = Color(0xFF7F91A4);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: textPrimary,
        surface: surface,
        onSurface: textPrimary,
        surfaceContainerHighest: Color(0xFF242F3D),
        primaryContainer: Color(0xFF1D2A39),
        onPrimaryContainer: textPrimary,
        secondary: primary,
        outline: textSecondary,
        outlineVariant: Color(0xFF242F3D),
      ),
      scaffoldBackgroundColor: background,
      canvasColor: surface,
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          titleLarge: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          titleMedium: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          bodyLarge: TextStyle(color: textPrimary),
          bodyMedium: TextStyle(color: textSecondary),
          labelLarge: TextStyle(color: primary, fontWeight: FontWeight.w600),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.05),
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: primary),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: textPrimary,
        elevation: 4,
      ),
    );
  }
}
