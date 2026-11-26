import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'user.dart';

class UsersCache {
  Future<File> _file() async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/users.json');
  }

  Future<void> save(List<User> users) async {
    final file = await _file();

    final content = jsonEncode(<Map<String, dynamic>>[
      for (final user in users) user.toJson(),
    ]);

    await file.writeAsString(content, flush: true);
  }

  Future<List<User>?> load() async {
    final file = await _file();

    if (!await file.exists()) {
      return null;
    }

    final text = await file.readAsString();
    final data = jsonDecode(text);

    final list = data as List<dynamic>;

    return list.map((item) {
      return User.fromJson(item as Map<String, dynamic>);
    }).toList();
  }
}
