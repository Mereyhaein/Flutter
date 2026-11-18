import 'package:flutter/foundation.dart';

import '../../core/api/api_exception.dart';
import 'user.dart';
import 'user_repository.dart';

class UsersModel extends ChangeNotifier {
  UsersModel(this._repo);

  final UserRepository _repo;

  List<User> items = const [];

  ApiException? error;

  bool loading = false;
  bool saving = false;

  Future<void> load() async {
    if (loading) return;

    loading = true;
    error = null;

    notifyListeners();

    try {
      items = await _repo.getAll();
    } on ApiException catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<User> create(User draft) async {
    if (saving) {
      throw StateError('Save already in progress');
    }

    saving = true;
    notifyListeners();

    try {
      final createdUser = await _repo.create(draft);

      items = [createdUser, ...items];

      notifyListeners();

      return createdUser;
    } finally {
      saving = false;
      notifyListeners();
    }
  }

  Future<User> getById(int id) {
    return _repo.getById(id);
  }

  @override
  void dispose() {
    _repo.dispose();
    super.dispose();
  }
}
