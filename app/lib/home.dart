import 'package:app/global/api.dart';
import 'package:app/utils/future_widget.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Icon(Icons.adjust_rounded)));
}
