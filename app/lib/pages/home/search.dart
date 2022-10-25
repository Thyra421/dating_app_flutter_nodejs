import 'dart:async';
import 'package:app/global/api.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  List<Map<String, dynamic>>? _matchesList;
  Duration _duration = const Duration(minutes: 48, seconds: 13);
  late Timer _timer;
  bool _loading = false;

  void _onSearch() async {
    try {
      setState(() => _loading = true);
      List<Map<String, dynamic>> matches = await Api.search();
      setState(() {
        _matchesList = matches;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Widget _match(
    int index,
    String firstName,
    String lastName,
    int matchesCount,
    String description,
  ) =>
      Container(
        margin: const EdgeInsets.symmetric(
            horizontal: kHorizontalPadding, vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadius),
            color: Theme.of(context).inputDecorationTheme.fillColor),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 20),
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: const Icon(Icons.person,
                        color: Colors.black, size: 40)),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text.rich(TextSpan(
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: "$firstName "),
                        TextSpan(text: lastName)
                      ])),
                  Text("You have $matchesCount hobbies in common!")
                ]),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(description, textAlign: TextAlign.justify),
            )
          ],
        ),
      );

  Widget _searchButton() => Center(
      child: IconButton(icon: const Icon(Icons.search), onPressed: _onSearch));

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

  Widget _matches() => ListView(
      padding: const EdgeInsets.symmetric(vertical: kHorizontalPadding),
      children: _matchesList!
          .asMap()
          .entries
          .map((MapEntry<int, Map<String, dynamic>> entry) => _match(
                entry.key,
                entry.value['identity']['firstName'],
                entry.value['identity']['lastName'],
                entry.value['commonHobbiesCount'],
                entry.value['identity']['description'],
              ))
          .toList());

  Widget _loadingIndicator() =>
      const Center(child: CircularProgressIndicator());

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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(children: [
      Expanded(
          child: _loading
              ? _loadingIndicator()
              : _matchesList == null
                  ? _searchButton()
                  : _matches()),
      // _timeIndicator()
    ]);
  }
}
