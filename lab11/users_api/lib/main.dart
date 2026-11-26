import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/api_client.dart';
import 'core/storage/secure_store.dart';
import 'features/auth/auth_model.dart';
import 'features/auth/login_screen.dart';
import 'features/settings/settings_model.dart';
import 'features/users/user_repository.dart';
import 'features/users/users_cache.dart';
import 'features/users/users_model.dart';
import 'features/users/users_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved settings before showing the app.
  final prefs = SharedPreferencesAsync();

  final dark = await prefs.getBool('darkMode') ?? false;
  final city = await prefs.getString('cityFilter');

  // Read the securely stored token.
  final secureStore = SecureStore();
  final token = await secureStore.readToken();

  // Create HTTP, API, Repository and Cache.
  final api = ApiClient(http.Client(), secureStore);

  final repository = UserRepository(api, UsersCache());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsModel>(
          create: (_) => SettingsModel(prefs, dark: dark, city: city),
        ),
        ChangeNotifierProvider<AuthModel>(
          create: (_) => AuthModel(secureStore, token),
        ),
        ChangeNotifierProvider<UsersModel>(
          create: (_) => UsersModel(repository)..load(),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();
    final auth = context.watch<AuthModel>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Practice 12 - Survive a Restart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: settings.dark ? ThemeMode.dark : ThemeMode.light,
      home: auth.signedIn ? const UsersScreen() : const LoginScreen(),
    );
  }
}
