import 'package:flutter/material.dart';

import 'models/screening.dart';
import 'models/profile.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';

class Routes {
  Routes._();
  static const shell = '/';
  static const detail = '/detail';
  static const form = '/form';
}

class DetailArgs {
  final Screening screening;
  final Profile profile;
  final ValueChanged<Screening> onUpdate;
  final VoidCallback onDelete;
  final VoidCallback onGoToProfileTab;

  DetailArgs({
    required this.screening,
    required this.profile,
    required this.onUpdate,
    required this.onDelete,
    required this.onGoToProfileTab,
  });
}

class FormArgs {
  final Screening? screening;
  FormArgs({this.screening});
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.detail:
      final args = settings.arguments as DetailArgs;
      return MaterialPageRoute(builder: (_) => DetailScreen(args: args));
    case Routes.form:
      final args = settings.arguments as FormArgs? ?? FormArgs();
      return MaterialPageRoute(builder: (_) => FormScreen(args: args));
    default:
      return onUnknownRoute(settings);
  }
}

// R25: отдельная функция для MaterialApp.onUnknownRoute
Route<dynamic> onUnknownRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (_) => const Scaffold(body: Center(child: Text('Not found'))),
  );
}
