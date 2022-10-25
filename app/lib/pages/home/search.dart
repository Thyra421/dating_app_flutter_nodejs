import 'dart:async';
import 'package:app/global/api.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>>? _matchesList;
  Duration _duration = const Duration(minutes: 48, seconds: 13);
  late Timer _timer;

  void _onSearch() async {
    try {
      List<Map<String, dynamic>> matches = await Api.search();
      setState(() => _matchesList = matches);
    } catch (e) {}
  }

  Widget _searchButton() =>
      IconButton(icon: const Icon(Icons.search), onPressed: () {});

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
              TextButton(onPressed: _onSearch, child: const Text("Subscribe")),
              const Text("to get unlimited search.")
            ],
          ),
        ],
      );

  Widget _matches() => ListView(
      children: _matchesList!.map((e) => Text(e['firstName'])).toList());

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
  Widget build(BuildContext context) => Column(children: [
        Expanded(
            child: _matchesList == null
                ? Center(child: _searchButton())
                : _matches()),
        _timeIndicator()
      ]);
}
