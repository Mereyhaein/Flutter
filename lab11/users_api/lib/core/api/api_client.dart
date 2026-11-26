import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../storage/secure_store.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient(
    this._client,
    this._store, {
    this.host = 'jsonplaceholder.typicode.com',
  });

  final http.Client _client;
  final SecureStore _store;
  final String host;

  Uri uri(String path, [Map<String, String>? query]) {
    return Uri.https(host, path, query);
  }

  Future<Map<String, String>> _headers({bool jsonBody = false}) async {
    final token = await _store.readToken();

    return <String, String>{
      'Accept': 'application/json',
      if (jsonBody) 'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      final response = await call().timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        developer.log(
          '${response.request?.method} '
          '${response.request?.url.path} '
          '-> ${response.statusCode}',
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

    if (status < 200 || status >= 300) {
      throw BadResponseException('Unexpected HTTP status: $status');
    }
  }

  dynamic _decode(http.Response response) {
    try {
      return jsonDecode(response.body);
    } on FormatException catch (error) {
      throw BadResponseException('Invalid JSON: $error');
    }
  }

  Future<dynamic> get(String path, [Map<String, String>? query]) async {
    final response = await _send(
      () async => _client.get(uri(path, query), headers: await _headers()),
    );

    _check(response);

    return _decode(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final response = await _send(
      () async => _client.post(
        uri(path),
        headers: await _headers(jsonBody: true),
        body: jsonEncode(body),
      ),
    );

    _check(response);

    if (response.statusCode != 201) {
      throw BadResponseException(
        'Expected HTTP 201, '
        'got ${response.statusCode}',
      );
    }

    return _decode(response);
  }

  void close() {
    _client.close();
  }
}
