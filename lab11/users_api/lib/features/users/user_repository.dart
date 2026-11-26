import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';

import 'user.dart';
import 'users_cache.dart';

typedef UsersResult = ({List<User> items, bool fromCache});

class UserRepository {
  UserRepository(this._api, this._cache);

  final ApiClient _api;
  final UsersCache _cache;

  Future<UsersResult> getAll() async {
    try {
      final data = await _api.get('/users');

      final raw = data as List<dynamic>;

      final users = raw.map((item) {
        return User.fromJson(item as Map<String, dynamic>);
      }).toList();

      await _cache.save(users);

      return (items: users, fromCache: false);
    } on NoConnectionException {
      List<User>? cached;

      try {
        cached = await _cache.load();
      } catch (error) {
        throw BadResponseException('Cannot read saved users: $error');
      }

      if (cached == null) {
        rethrow;
      }

      return (items: cached, fromCache: true);
    } on ApiException {
      rethrow;
    } catch (error) {
      throw BadResponseException('users: $error');
    }
  }

  Future<User> getById(int id) async {
    try {
      final data = await _api.get('/users/$id');

      return User.fromJson(data as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (error) {
      throw BadResponseException('users/$id: $error');
    }
  }

  Future<User> create(User draft) async {
    try {
      final data = await _api.post('/users', draft.toJson());

      return User.fromJson(data as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (error) {
      throw BadResponseException('create user: $error');
    }
  }

  void dispose() {
    _api.close();
  }
}
