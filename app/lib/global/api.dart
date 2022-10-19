import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Api {
  static const String _kEndpoint = 'http://localhost:8080';
  static const Duration _kTimeoutDuration = Duration(seconds: 10);
  static String _token = "";

  static Uri _url(String route) => Uri.parse("$_kEndpoint/$route");

  static void _setToken(String token) => _token = token;

  static Map<String, String> _headers({bool authorization = true}) {
    Map<String, String> headers = {'content-type': 'application/json'};
    if (authorization) headers.addEntries({"Authorization": _token}.entries);
    return headers;
  }

  static Future<T> _request<T>({
    required Future<http.Response> Function() query,
    required T Function(String body) onSuccess,
  }) async {
    try {
      final http.Response response = await query().timeout(_kTimeoutDuration);
      if (response.statusCode == 200) return onSuccess(response.body);
      return Future.error(jsonDecode(response.body));
    } on TimeoutException catch (_) {
      return Future.error({"value": "Request timeout", "code": 504});
    } on SocketException catch (_) {
      return Future.error({"value": "Server unreachable", "code": 503});
    } catch (_) {
      return Future.error({"value": "Uncategorized error", "code": 400});
    }
  }

  static void logout() {
    _token = "";
  }

  static Future<void> login({
    required String mail,
    required String password,
  }) async =>
      _request(
          query: () => http.post(_url('login'),
              headers: _headers(authorization: false),
              body: jsonEncode({"mail": mail, 'password': password})),
          onSuccess: (String body) => _setToken(body));

  static Future<void> register({
    required String mail,
    required String password,
  }) async =>
      _request(
          query: () => http.post(_url('register'),
              headers: _headers(authorization: false),
              body: jsonEncode({"mail": mail, 'password': password})),
          onSuccess: (String body) => _setToken(body));

  static Future<Map<String, dynamic>> getSettings() async => _request(
      query: () => http.get(_url('settings'), headers: _headers()),
      onSuccess: (String body) => Map<String, dynamic>.from(jsonDecode(body)));

  static Future<void> setSettings(String name, bool value) async => _request(
      query: () => http.put(_url('settings'),
          headers: _headers(), body: jsonEncode({name: value})),
      onSuccess: (_) => {});

  static Future<List<String>> getHobbies() async => _request(
      query: () => http.get(_url('hobbies'), headers: _headers()),
      onSuccess: (String body) => List<String>.from(jsonDecode(body)));

  static Future<void> setHobbies(List<String> hobbies) async => _request(
      query: () => http.put(_url('hobbies'),
          headers: _headers(), body: jsonEncode(hobbies)),
      onSuccess: (_) => {});
}
