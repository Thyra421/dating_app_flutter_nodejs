import 'package:flutter/material.dart';

class Messenger {
  static late GlobalKey<ScaffoldMessengerState> _messengerKey;

  static setMessengerrKey(GlobalKey<ScaffoldMessengerState> key) =>
      _messengerKey = key;

  static void showSnackBar(String content) => _messengerKey.currentState!
      .showSnackBar(SnackBar(content: Text(content)));
}
