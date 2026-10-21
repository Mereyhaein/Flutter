import 'package:flutter/material.dart';

// R2: enum с label и иконкой, используется в exhaustive switch для цвета
enum MovieGenre {
  action('Action', Icons.local_fire_department),
  comedy('Comedy', Icons.emoji_emotions),
  drama('Drama', Icons.theater_comedy),
  horror('Horror', Icons.nightlight_round),
  documentary('Documentary', Icons.camera_alt);

  final String label;
  final IconData icon;
  const MovieGenre(this.label, this.icon);

  // R2: exhaustive switch expression -> colorScheme role
  Color colorOf(ColorScheme scheme) => switch (this) {
    MovieGenre.action => scheme.error,
    MovieGenre.comedy => scheme.tertiary,
    MovieGenre.drama => scheme.primary,
    MovieGenre.horror => scheme.secondary,
    MovieGenre.documentary => scheme.primaryContainer,
  };

  // Временно — одна картинка для всех жанров, пока не добавлены свои
  String get imageAsset => 'assets/images/placeholder.jpg';
}
