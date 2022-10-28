import 'dart:async';
import 'package:app/data/steps_data.dart';
import 'package:flutter/material.dart';

import 'package:app/global/api.dart';
import 'package:app/global/navigation.dart';
import 'package:app/global/storage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  static const double _scaleBig = .8;
  static const double _scaleSmall = .7;
  static const Duration _speed = Duration(milliseconds: 200);
  late Timer _timer;
  double _scale = _scaleBig;
  int _counter = 0;

  void _dispatch() async {
    String token = readStorage('token');
    Api.setToken(token);
    try {
      StepsData steps = await Api.getSteps();
      if (!steps.identity!) return Navigation.identity(replace: true);
      if (!steps.gettingStarted!)
        return Navigation.gettingStarted(replace: true);
      return Navigation.home(replace: true);
    } catch (e) {
      return Navigation.login(replace: true);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        _speed,
        (Timer timer) => setState(() {
              _counter = (_counter + 1) % 10;
              if (_counter >= 4) return;
              if (_scale == _scaleBig)
                _scale = _scaleSmall;
              else
                _scale = _scaleBig;
            }));
    _dispatch();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
          child: AnimatedScale(
              duration: _speed,
              scale: _scale,
              child: Image.asset('assets/images/lust.png'))));
}
