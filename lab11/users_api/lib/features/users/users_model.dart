import 'package:flutter/foundation.dart';

import '../../core/api/api_exception.dart';

import 'user.dart';
import 'user_repository.dart';

class UsersModel extends ChangeNotifier {
  UsersModel(this._repo);

  final UserRepository _repo;

  List<User> items = const <User>[];

  ApiException? error;

  bool loading = false;
  bool saving = false;
  bool fromCache = false;

  bool _disposed = false;

  Future<void> load() async {
    if (loading || _disposed) {
      return;
    }

    loading = true;
    error = null;

    notifyListeners();

    try {
      final result = await _repo.getAll();

      if (_disposed) return;

      items = result.items;
      fromCache = result.fromCache;
    } on ApiException catch (exception) {
      if (_disposed) return;

      error = exception;
    } finally {
      if (!_disposed) {
        loading = false;
        notifyListeners();
      }
    }
  }

  Future<User> create(User draft) async {
    if (saving) {
      throw StateError('Save already in progress');
    }

    saving = true;
    notifyListeners();

    try {
      final created = await _repo.create(draft);

      if (!_disposed) {
        items = <User>[created, ...items];

        notifyListeners();
      }

      return created;
    } finally {
      if (!_disposed) {
        saving = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;

    _repo.dispose();

    super.dispose();
  }
}
