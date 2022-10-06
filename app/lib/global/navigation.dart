import 'package:app/pages/login.dart';
import 'package:app/pages/register.dart';
import 'package:flutter/material.dart';

import '../home.dart';

class Navigation {
  static late GlobalKey<NavigatorState> _navigatorKey;

  static setNavigatorKey(GlobalKey<NavigatorState> key) => _navigatorKey = key;

  static Future _push(Widget child, {Function? then, bool replace = false}) =>
      (replace
              ? _navigatorKey.currentState!.pushReplacement(
                  MaterialPageRoute(builder: (context) => child))
              : _navigatorKey.currentState!
                  .push(MaterialPageRoute(builder: (context) => child)))
          .then((value) {
        if (then != null) then();
      });

  static void home({Function? then, bool replace = false}) =>
      _push(const Home(), replace: replace, then: then);

  static void login({Function? then, bool replace = false}) =>
      _push(const LoginPage(), replace: replace, then: then);

  static void register({Function? then, bool replace = false}) =>
      _push(const RegisterPage(), replace: replace, then: then);
}