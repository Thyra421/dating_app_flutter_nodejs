import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app/data/identity_data.dart';
import 'package:app/data/match_data.dart';
import 'package:app/data/settings_data.dart';
import 'package:app/global/storage.dart';
import 'package:http/http.dart' as http;

import '../data/steps_data.dart';

class Api {
  static const String _kEndpoint = 'http://localhost:8080';
  static const Duration _kTimeoutDuration = Duration(seconds: 10);
  static String _token = "";

  static Uri _url(String route) => Uri.parse("$_kEndpoint/$route");

  static void setToken(String token) => _token = token;

  static Map<String, String> _headers({bool authorization = true}) => {
        'content-type': 'application/json',
        if (authorization) "Authorization": _token
      };

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
    clearStorage('token');
  }

  static Future<void> login({
    required String mail,
    required String password,
  }) async =>
      _request(
          query: () => http.post(_url('login'),
              headers: _headers(authorization: false),
              body: jsonEncode({
                "mail": mail,
                'password': password,
              })),
          onSuccess: (String body) {
            setToken(body);
            writeStorage('token', body);
          });

  static Future<void> register({
    required String mail,
    required String password,
  }) async =>
      _request(
          query: () => http.post(_url('register'),
              headers: _headers(authorization: false),
              body: jsonEncode({"mail": mail, 'password': password})),
          onSuccess: (String body) {
            setToken(body);
            writeStorage('token', body);
          });

  static Future<SettingsData> getSettings() async => _request(
      query: () => http.get(_url('settings'), headers: _headers()),
      onSuccess: (String body) => SettingsData.fromJson(jsonDecode(body)));

  static Future<void> setSettings({
    bool? notifications,
    bool? appearOnRadar,
    bool? trackPosition,
    bool? darkMode,
    String? language,
  }) async =>
      _request(
          query: () => http.put(_url('settings'),
              headers: _headers(),
              body: jsonEncode({
                if (notifications != null) "notifications": notifications,
                if (appearOnRadar != null) "appearOnRadar": appearOnRadar,
                if (trackPosition != null) "trackPosition": trackPosition,
                if (darkMode != null) "darkMode": darkMode,
                if (language != null) "language": language,
              })),
          onSuccess: (_) => {});

  static Future<List<String>> getHobbies() async => _request(
      query: () => http.get(_url('hobbies'), headers: _headers()),
      onSuccess: (String body) => List<String>.from(jsonDecode(body)));

  static Future<void> setHobbies(List<String> hobbies) async => _request(
      query: () => http.put(_url('hobbies'),
          headers: _headers(), body: jsonEncode(hobbies)),
      onSuccess: (_) => {});

  static Future<StepsData> getSteps() async => _request(
      query: () => http.get(_url('steps'), headers: _headers()),
      onSuccess: (String body) => StepsData.fromJson(jsonDecode(body)));

  static Future<void> setSteps({
    bool? identity,
    bool? gettingStarted,
    bool? confirmMail,
  }) async =>
      _request(
          query: () => http.put(_url('steps'),
              headers: _headers(),
              body: jsonEncode({
                if (identity != null) "identity": identity,
                if (gettingStarted != null) "gettingStarted": gettingStarted,
                if (confirmMail != null) "confirmMail": confirmMail,
              })),
          onSuccess: (_) => {});

  static Future<IdentityData> getIdentity() async => _request(
      query: () => http.get(_url('identity'), headers: _headers()),
      onSuccess: (String body) => IdentityData.fromJson(jsonDecode(body)));

  static Future<void> setIdentity({
    String? firstName,
    String? lastName,
    String? gender,
    String? dateOfBirth,
    String? description,
  }) async =>
      _request(
          query: () => http.put(_url('identity'),
              headers: _headers(),
              body: jsonEncode({
                if (firstName != null) 'firstName': firstName,
                if (lastName != null) 'lastName': lastName,
                if (gender != null) 'gender': gender,
                if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
                if (description != null) 'description': description
              })),
          onSuccess: (_) => {});

  static Future<List<MatchData>> search() async => _request(
      query: () => http.get(_url('search?maxMatches=5&maxDistance=30'),
          headers: _headers()),
      onSuccess: (String body) =>
          List<Map<String, dynamic>>.from(jsonDecode(body))
              .map((e) => MatchData.fromJson(e))
              .toList());
}
