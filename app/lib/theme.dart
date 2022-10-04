import 'package:flutter/material.dart';

const double kBorderRadius = 10;
const Color kThemeColor = Color.fromARGB(255, 230, 32, 32); // lust

MaterialColor _materialColor() => MaterialColor(kThemeColor.value, const {
      50: kThemeColor,
      100: kThemeColor,
      200: kThemeColor,
      300: kThemeColor,
      400: kThemeColor,
      500: kThemeColor,
      600: kThemeColor,
      700: kThemeColor,
      800: kThemeColor,
      900: kThemeColor,
    });

ThemeData darkTheme() => ThemeData(
    canvasColor: const Color(0xFF121212),
    primarySwatch: _materialColor(),
    textTheme: const TextTheme(
        subtitle1: TextStyle(color: Colors.black)), // input field
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.resolveWith((states) =>
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kBorderRadius))))),
    brightness: Brightness.dark,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      floatingLabelStyle: const TextStyle(color: kThemeColor),
      labelStyle: const TextStyle(color: Colors.grey),
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide.none),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide.none),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: Colors.red)),
    ));
