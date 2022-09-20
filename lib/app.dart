import 'package:app/theme.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: darkTheme(),
        home: const LoginPage(),
      );
}
