import 'package:flutter/foundation.dart';

import '../../core/storage/secure_store.dart';

class AuthModel extends ChangeNotifier {
  AuthModel(this._store, this._token);

  final SecureStore _store;

  String? _token;

  bool get signedIn {
    return _token?.isNotEmpty ?? false;
  }

  Future<void> login(String email, String password) async {
    if (password.length < 8) {
      throw const FormatException('Password needs at least 8 characters');
    }

    await Future<void>.delayed(const Duration(seconds: 1));

    // Fake login: no real authentication server.
    final token = 'tok_${email.hashCode}';

    await _store.saveToken(token);

    _token = token;

    notifyListeners();
  }

  Future<void> logout() async {
    await _store.clear();

    _token = null;

    notifyListeners();
  }

  Future<String?> readTokenForDebug() async {
    if (!kDebugMode) {
      return null;
    }

    return _store.readToken();
  }
}
