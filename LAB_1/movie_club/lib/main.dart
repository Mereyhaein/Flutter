import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';
import 'shell/app_shell.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) => setState(() => _themeMode = mode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Club',
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: _themeMode,
      initialRoute: Routes.shell,
      onGenerateRoute: onGenerateRoute,
      onUnknownRoute: onUnknownRoute,
      routes: {
        Routes.shell: (_) =>
            AppShell(themeMode: _themeMode, onThemeModeChanged: _setThemeMode),
      },
    );
  }
}
