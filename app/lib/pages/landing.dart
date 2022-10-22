import 'package:app/global/api.dart';
import 'package:app/global/navigation.dart';
import 'package:app/global/storage.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void _dispatch() async {
    String token = readStorage('token');
    Api.setToken(token);
    try {
      Map<String, dynamic> steps = await Api.getSteps();
      if (!steps['identity']) return Navigation.identity(replace: true);
      if (!steps['gettingStarted'])
        return Navigation.gettingStarted(replace: true);
      return Navigation.home(replace: true);
    } catch (e) {
      return Navigation.login(replace: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _dispatch();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
              child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Image.asset('assets/images/lust.png'),
      )));
}
