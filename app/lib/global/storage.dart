import 'dart:io';
import 'package:app/data/error_data.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

Future<String> readStorage(String key) async {
  // Web
  if (kIsWeb) {
    if (!html.window.localStorage.containsKey(key))
      return Future.error(ErrorData(value: "File not found"));
    return html.window.localStorage[key]!;
  }

  // Android
  if (Platform.isAndroid) {
    Directory directory = await getApplicationSupportDirectory();
    String path = '${directory.path}/key';
    File file = File.fromUri(Uri.file(path));
    if (!await file.exists())
      return Future.error(ErrorData(value: "File not found"));
    return file.readAsString();
  }

  return Future.error(ErrorData(value: "Unsupported platform"));
}

Future<void> writeStorage(String key, String value) async {
  // Web
  if (kIsWeb) {
    html.window.localStorage[key] = value;
    return;
  }

  // Android
  if (Platform.isAndroid) {
    Directory directory = await getApplicationSupportDirectory();
    String path = '${directory.path}/key';
    File file = File.fromUri(Uri.file(path));
    if (!await file.exists()) file.create();
    await file.writeAsString(value);
    return;
  }

  return Future.error(ErrorData(value: "Unsupported platform"));
}

Future<void> clearStorage(String key) async {
  // Web
  if (kIsWeb) {
    if (html.window.localStorage.containsKey(key))
      html.window.localStorage.remove(key);
    return;
  }

  // Android
  if (Platform.isAndroid) {
    Directory directory = await getApplicationSupportDirectory();
    String path = '${directory.path}/key';
    File file = File.fromUri(Uri.file(path));
    if (await file.exists()) file.create();
    await file.delete();
    return;
  }

  return Future.error(ErrorData(value: "Unsupported platform"));
}
