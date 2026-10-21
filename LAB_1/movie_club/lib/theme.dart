import 'package:flutter/material.dart';

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: brightness,
  );
  return ThemeData(colorScheme: scheme, useMaterial3: true);
}
