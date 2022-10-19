import 'package:app/theme.dart';
import 'package:flutter/material.dart';

import 'pages/login.dart';

class App extends StatelessWidget {
  const App(this.navigatorKey, {super.key});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Lust',
        debugShowCheckedModeBanner: false,
        theme: darkTheme(),
        home: const LoginPage(),
      );
}
