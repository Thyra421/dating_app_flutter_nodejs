import 'dart:html';
import 'package:flutter/foundation.dart';

String readStorage(String key) {
  // Web
  if (kIsWeb)
    return window.localStorage.containsKey(key)
        ? window.localStorage[key]!
        : "";

  return "";
}

void writeStorage(String key, String value) {
  // Web
  if (kIsWeb) window.localStorage[key] = value;
}

void clearStorage(String key) {
  // Web
  if (kIsWeb) window.localStorage.remove(key);
}
