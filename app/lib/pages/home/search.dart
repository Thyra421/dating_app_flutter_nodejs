import 'dart:async';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Widget _searchButton() => const Icon(Icons.search);

  Duration _duration = Duration(minutes: 48, seconds: 13);

  late Timer _timer;

  Widget _timeIndicator() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(TextSpan(children: [
            const TextSpan(text: "Next search available in "),
            TextSpan(
                text: "${_duration.toString().split('.').first}.",
                style: const TextStyle(fontWeight: FontWeight.bold))
          ], style: const TextStyle(fontSize: 14))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: () {}, child: const Text("Subscribe")),
              const Text("to get unlimited search.")
            ],
          ),
        ],
      );

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) =>
            setState(() => _duration -= const Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) => Container(
          child: Column(children: [
        Expanded(child: Center(child: _searchButton())),
        _timeIndicator()
      ]));
}
