import 'package:flutter/material.dart';

const double kBorderRadius = 10;
const Color kThemeColor = Color.fromARGB(255, 230, 32, 32); // lust
const Color kBackgroundColor = Color(0xFF121212);

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
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: _materialColor(),
      brightness: Brightness.dark,
    ).copyWith(secondary: _materialColor()),
    canvasColor: kBackgroundColor,
    textTheme: const TextTheme(
        subtitle1: TextStyle(color: Colors.black)), // input field
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.resolveWith((states) =>
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kBorderRadius))))),
    appBarTheme: const AppBarTheme(
        color: kBackgroundColor, shadowColor: Colors.transparent),
    switchTheme: SwitchThemeData(
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.selected))
        return kThemeColor.withAlpha(100);
      return Colors.grey.withAlpha(100);
    }), thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.selected)) return kThemeColor;
      return Colors.grey;
    })),
    tabBarTheme: const TabBarTheme(
        labelColor: kThemeColor,
        unselectedLabelColor: Colors.white,
        indicator: BoxDecoration(color: Colors.transparent)),
    dividerColor: Colors.grey.shade700,
    listTileTheme: const ListTileThemeData(
        textColor: Colors.white, tileColor: kBackgroundColor),
    snackBarTheme: SnackBarThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius)),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: const TextStyle(color: Colors.red)),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
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
