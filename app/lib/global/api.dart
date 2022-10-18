import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const _kEndpoint = 'http://localhost:8080';
  static const _kTokenTest =
      "eyJhbGciOiJIUzI1NiJ9.NjM0ZTlhOTc1ZjJjNGM4NjVhYzU2NGU0.dJN_-WGOXj4VdsYWDimAG8k-WyGFBZpFvQ8kHWU6HqE";

  static Uri _url(String route) => Uri.parse("$_kEndpoint/$route");

  static Map<String, String> _headers({bool authorization = true}) {
    Map<String, String> headers = {'content-type': 'application/json'};
    if (authorization)
      headers.addEntries({"Authorization": _kTokenTest}.entries);
    return headers;
  }

  static Future<T> _request<T>({
    required Future<http.Response> Function() query,
  }) async {
    try {
      http.Response response = await query();

      if (response.statusCode != 200) {
        Map<String, dynamic> error = jsonDecode(response.body);
        print(error);
        return Future.error("Error: ${error['value']}");
      }

      return jsonDecode(response.body);
    } catch (e) {
      return Future.error("Server error");
    }
  }

  static Future<bool> login({
    required String mail,
    required String password,
  }) async =>
      _request(
          query: () => http.post(_url('login'),
              headers: _headers(authorization: false),
              body: jsonEncode({"mail": mail, 'password': password})));

  static Future<bool> register({
    required String mail,
    required String password,
  }) async =>
      _request(
          query: () => http.post(_url('register'),
              headers: _headers(authorization: false),
              body: jsonEncode({"mail": mail, 'password': password})));

  static Future<Map<String, dynamic>> getSettings() async =>
      _request(query: () => http.get(_url('settings'), headers: _headers()));

  static Future<Map<String, dynamic>> _setSettings(
          String name, bool value) async =>
      _request(
          query: () => http
              .put(_url('settings'), headers: _headers(), body: {name: value}));
}
