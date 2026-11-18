import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiClient {
  ApiClient(this._client, {this.host = 'jsonplaceholder.typicode.com'});

  final http.Client _client;
  final String host;

  Map<String, String> get headers => const {'Accept': 'application/json'};

  Uri uri(String path, [Map<String, String>? query]) {
    return Uri.https(host, path, query);
  }

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      final response = await call().timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        developer.log(
          '${response.request?.method} '
          '${response.request?.url} '
          '${response.statusCode}',
          name: 'api',
        );
      }

      return response;
    } on SocketException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    } on http.ClientException {
      throw const NoConnectionException();
    }
  }

  void _check(http.Response response) {
    final status = response.statusCode;

    if (status == 401) {
      throw const UnauthorizedException();
    }

    if (status == 404) {
      throw const NotFoundException();
    }

    if (status >= 500) {
      throw ServerException(status);
    }

    if (status >= 400) {
      throw BadResponseException('HTTP error: $status');
    }
  }

  dynamic _decode(http.Response response) {
    try {
      return jsonDecode(response.body);
    } on FormatException catch (e) {
      throw BadResponseException('Invalid JSON: $e');
    }
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final response = await _send(
      () => _client.get(uri(path, query), headers: headers),
    );

    _check(response);

    if (response.statusCode != 200) {
      throw BadResponseException('Expected 200, got ${response.statusCode}');
    }

    return _decode(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final response = await _send(
      () => _client.post(
        uri(path),
        headers: {...headers, 'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ),
    );

    _check(response);

    if (response.statusCode != 201) {
      throw BadResponseException('Expected 201, got ${response.statusCode}');
    }

    return _decode(response);
  }

  void close() {
    _client.close();
  }
}
