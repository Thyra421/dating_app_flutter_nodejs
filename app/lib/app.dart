import 'package:lust/pages/landing.dart';
import 'package:lust/theme.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App(this.navigatorKey, this.messengerKey, {super.key});

  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: messengerKey,
        title: 'Lust',
        debugShowCheckedModeBanner: false,
        theme: darkTheme(),
        home: const LandingPage(),
      );
}
