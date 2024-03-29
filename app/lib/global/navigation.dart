import 'package:lust/data/pictures_data.dart';
import 'package:lust/pages/getting_started.dart';
import 'package:lust/pages/home/profile/pictures.dart';
import 'package:lust/pages/home/profile/settings/language.dart';
import 'package:lust/pages/home/profile/settings.dart';
import 'package:lust/pages/login.dart';
import 'package:lust/pages/register.dart';
import 'package:flutter/material.dart';
import '../pages/home.dart';
import '../pages/identity.dart';

class Navigation {
  static late GlobalKey<NavigatorState> _navigatorKey;

  static setNavigatorKey(GlobalKey<NavigatorState> key) => _navigatorKey = key;

  static Future _push({
    required Widget child,
    void Function(dynamic value)? then,
    bool replace = false,
  }) =>
      (replace
              ? _navigatorKey.currentState!.pushReplacement(
                  MaterialPageRoute(builder: (context) => child))
              : _navigatorKey.currentState!
                  .push(MaterialPageRoute(builder: (context) => child)))
          .then((value) {
        if (then != null) then(value);
      });

  static void pop<T extends Object?>([T? result]) =>
      _navigatorKey.currentState!.pop(result);

  static void home({
    void Function(dynamic value)? then,
    bool replace = false,
  }) =>
      _push(child: const Home(), replace: replace, then: then);

  static void login({
    void Function(dynamic value)? then,
    bool replace = false,
  }) =>
      _push(child: const LoginPage(), replace: replace, then: then);

  static void register({
    void Function(dynamic value)? then,
    bool replace = false,
  }) =>
      _push(child: const RegisterPage(), replace: replace, then: then);

  static void settings({
    void Function(dynamic value)? then,
    bool replace = false,
  }) =>
      _push(child: const SettingsPage(), replace: replace, then: then);

  static void language({
    void Function(dynamic value)? then,
    bool replace = false,
  }) =>
      _push(child: const LanguagePage(), replace: replace, then: then);

  static void identity({
    void Function(dynamic value)? then,
    bool replace = false,
  }) =>
      _push(child: const IdentityPage(), replace: replace, then: then);

  static void gettingStarted({
    void Function(dynamic value)? then,
    bool replace = false,
  }) =>
      _push(child: const GettingStartedPage(), replace: replace, then: then);

  static void pictures({
    void Function(dynamic value)? then,
    bool replace = false,
    required PicturesData initialPicturesData,
    required void Function(PicturesData newData) onChange,
  }) =>
      _push(
          child: PicturesPage(
            initialPicturesData: initialPicturesData,
            onChange: onChange,
          ),
          replace: replace,
          then: then);
}
