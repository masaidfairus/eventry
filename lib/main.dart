import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/utils/theme_provider.dart';
import 'core/utils/app_color.dart';

import 'features/splash_screen.dart';
import 'features/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _isDark = false;

  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      isDark: _isDark,
      toggleTheme: _toggleTheme,
      child: MaterialApp(
        theme: ThemeData(
          // scaffoldBackgroundColor: AppColors.background,
          // primaryColor: AppColors.primary,
          // colorScheme: ColorScheme.light(
          //   primary: AppColors.primary,
          //   secondary: AppColors.success,
          //   error: AppColors.danger,
          // ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          brightness: Brightness.light,
          textTheme: GoogleFonts.interTextTheme(),
        ),
        darkTheme: ThemeData(
          // scaffoldBackgroundColor: AppColors.background,
          // primaryColor: AppColors.primary,
          // colorScheme: ColorScheme.light(
          //   primary: AppColors.primary,
          //   secondary: AppColors.success,
          //   error: AppColors.danger,
          // ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.black,
          ),
          brightness: Brightness.dark,
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        ),
        themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
