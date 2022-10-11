import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const kEndpoint = 'http://localhost:8080';

  static Future<bool> login({
    required String mail,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(Uri.parse('$kEndpoint/login'),
          headers: {'content-type': 'application/json'},
          body: jsonEncode({"mail": mail, 'password': password}));
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> register({
    required String mail,
    required String password,
  }) async {
    http.Response response = await http.post(Uri.parse('$kEndpoint/register'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({"mail": mail, 'password': password}));
    return response.statusCode == 200;
  }
}
