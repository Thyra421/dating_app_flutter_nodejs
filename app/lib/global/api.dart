import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:lust/data/error_data.dart';
import 'package:lust/data/hobbies_data.dart';
import 'package:lust/data/identity_data.dart';
import 'package:lust/data/location_data.dart';
import 'package:lust/data/match_data.dart';
import 'package:lust/data/picture_data.dart';
import 'package:lust/data/pictures_data.dart';
import 'package:lust/data/relations_data.dart';
import 'package:lust/data/settings_data.dart';
import 'package:lust/global/storage.dart';
import 'package:http/http.dart' as http;

import '../data/steps_data.dart';

class Api {
  static const String _kEndpoint = 'http://3.250.3.51:8080';
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
      final http.Response response = await query();
      if (response.statusCode == 200) return onSuccess(response.body);
      return Future.error(ErrorData.fromJson(jsonDecode(response.body)));
    } on TimeoutException catch (_) {
      return Future.error(ErrorData(value: "Request timeout", code: 504));
    } on SocketException catch (_) {
      return Future.error(ErrorData(value: "Server unreachable", code: 503));
    } catch (_) {
      return Future.error(ErrorData(value: "Uncategorized error", code: 400));
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
      await _request(
          query: () => http.post(_url('login'),
              headers: _headers(authorization: false),
              body: jsonEncode({"mail": mail, 'password': password})),
          onSuccess: (String body) {
            setToken(body);
            writeStorage('token', body);
          });

  static Future<void> register({
    required String mail,
    required String password,
  }) async =>
      await _request(
          query: () => http.post(_url('register'),
              headers: _headers(authorization: false),
              body: jsonEncode({"mail": mail, 'password': password})),
          onSuccess: (String body) {
            setToken(body);
            writeStorage('token', body);
          });

  static Future<SettingsData> getSettings() async => await _request(
      query: () => http.get(_url('settings'), headers: _headers()),
      onSuccess: (String body) => SettingsData.fromJson(jsonDecode(body)));

  static Future<void> setSettings(SettingsData settingsData) async => _request(
      query: () => http.put(_url('settings'),
          headers: _headers(), body: jsonEncode(settingsData)),
      onSuccess: (_) => {});

  static Future<HobbiesData> getHobbies() async => await _request(
      query: () => http.get(_url('hobbies'), headers: _headers()),
      onSuccess: (String body) => HobbiesData.fromJson(jsonDecode(body)));

  static Future<void> setHobbies(List<String> hobbies) async => await _request(
      query: () => http.put(_url('hobbies'),
          headers: _headers(), body: jsonEncode(hobbies)),
      onSuccess: (_) => {});

  static Future<StepsData> getSteps() async => await _request(
      query: () => http.get(_url('steps'), headers: _headers()),
      onSuccess: (String body) => StepsData.fromJson(jsonDecode(body)));

  static Future<void> setSteps(StepsData stepsData) async => await _request(
      query: () => http.put(_url('steps'),
          headers: _headers(), body: jsonEncode(stepsData)),
      onSuccess: (_) => {});

  static Future<IdentityData> getIdentity() async => await _request(
      query: () => http.get(_url('identity'), headers: _headers()),
      onSuccess: (String body) => IdentityData.fromJson(jsonDecode(body)));

  static Future<void> setIdentity(IdentityData identityData) async =>
      await _request(
          query: () => http.put(_url('identity'),
              headers: _headers(), body: jsonEncode(identityData)),
          onSuccess: (_) => {});

  static Future<MatchData> search() async => await _request(
      query: () => http.get(_url('search'), headers: _headers()),
      onSuccess: (String body) => MatchData.fromJson(jsonDecode(body)));

  static Future<void> addRelations(RelationsData relationsData) async =>
      await _request(
          query: () => http.patch(_url('relations/add'),
              headers: _headers(), body: jsonEncode(relationsData)),
          onSuccess: (_) => {});

  static Future<void> removeRelations(RelationsData relationsData) async =>
      await _request(
          query: () => http.patch(_url('relations/remove'),
              headers: _headers(), body: jsonEncode(relationsData)),
          onSuccess: (_) => {});

  static Future<void> addHobbies(HobbiesData hobbiesData) async =>
      await _request(
          query: () => http.patch(_url('hobbies/add'),
              headers: _headers(), body: jsonEncode(hobbiesData)),
          onSuccess: (_) => {});

  static Future<void> removeHobbies(HobbiesData hobbiesData) async =>
      await _request(
          query: () => http.patch(_url('hobbies/remove'),
              headers: _headers(), body: jsonEncode(hobbiesData)),
          onSuccess: (_) => {});

  static Future<void> setLocation(LocationData locationData) async =>
      await _request(
          query: () => http.put(_url('location'),
              headers: _headers(), body: jsonEncode(locationData)),
          onSuccess: (_) => {});

  static Future<PicturesData> getPictures() async => await _request(
      query: () => http.get(_url('pictures'), headers: _headers()),
      onSuccess: (String body) => PicturesData.fromJson(jsonDecode(body)));

  static Future<void> setPictures(PicturesData picturesData) async =>
      await _request(
          query: () => http.put(_url('pictures'),
              headers: _headers(), body: jsonEncode(picturesData)),
          onSuccess: (_) => {});

  static Future<void> deletePicture(PictureData pictureData) async =>
      await _request(
          query: () => http.delete(_url('pictures'),
              headers: _headers(), body: jsonEncode(pictureData)),
          onSuccess: (_) => {});

  static Future<PictureData> addPicture(String path) async => await _request(
      query: () async {
        http.MultipartRequest request =
            http.MultipartRequest('POST', _url('pictures'));
        request.files.add(await http.MultipartFile.fromPath('picture', path));
        request.headers.addAll(_headers());
        http.StreamedResponse response = await request.send();
        return http.Response.fromStream(response);
      },
      onSuccess: (String body) => PictureData.fromJson(jsonDecode(body)));
}
