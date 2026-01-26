import 'package:flutter/material.dart';

class ThemeProvider extends InheritedWidget {
  final bool isDark;
  final bool isLoggedIn;
  final VoidCallback toggleTheme;
  final VoidCallback login;
  final VoidCallback logout;

  const ThemeProvider({
    super.key,
    required this.isDark,
    required this.isLoggedIn,
    required this.toggleTheme,
    required this.login,
    required this.logout,
    required super.child,
  });

  static ThemeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>()!;
  }

  @override
  bool updateShouldNotify(covariant ThemeProvider oldWidget) {
    return oldWidget.isDark != isDark || oldWidget.isLoggedIn != isLoggedIn;
  }
}
