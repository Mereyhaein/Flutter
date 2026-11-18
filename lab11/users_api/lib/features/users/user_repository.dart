import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';

class UserRepository {
  UserRepository(this._api);

  final ApiClient _api;

  Future<List<User>> getAll() async {
    try {
      final data = await _api.get('/users');

      final users = data as List<dynamic>;

      return users.map((item) {
        return User.fromJson(item as Map<String, dynamic>);
      }).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw BadResponseException('users: $e');
    }
  }

  Future<User> getById(int id) async {
    try {
      final data = await _api.get('/users/$id');

      return User.fromJson(data as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw BadResponseException('users/$id: $e');
    }
  }

  Future<User> create(User draft) async {
    try {
      final data = await _api.post('/users', draft.toJson());

      return User.fromJson(data as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw BadResponseException('create user: $e');
    }
  }

  void dispose() {
    _api.close();
  }
}
