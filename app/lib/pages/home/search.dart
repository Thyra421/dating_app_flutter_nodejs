import 'dart:async';
import 'package:app/data/match_data.dart';
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
  List<MatchData>? _matchesList;
  Duration _duration = const Duration(minutes: 48, seconds: 13);
  late Timer _timer;
  bool _loading = false;

  void _onSearch() async {
    try {
      setState(() => _loading = true);
      List<MatchData> matches = await Api.search();
      setState(() {
        _matchesList = matches;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Widget _match(MatchData matchData) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius),
          color: Theme.of(context).inputDecorationTheme.fillColor),
      child: Column(children: [
        Row(children: [
          Container(
              margin: const EdgeInsets.only(right: 20),
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: const Icon(Icons.person, color: Colors.black, size: 40)),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text.rich(TextSpan(
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(text: "${matchData.matchIdentity!.firstName!}, "),
                  TextSpan(
                      text: (matchData.matchIdentity!.dateOfBirth!
                                  .difference(DateTime.now())
                                  .inDays /
                              365)
                          .floor()
                          .abs()
                          .toString())
                ])),
            Text.rich(TextSpan(children: [
              const TextSpan(text: "You have "),
              TextSpan(
                  text: matchData.commonHobbiesCount!.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: " hobbies in common")
            ]))
          ])
        ]),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(matchData.matchIdentity!.description!,
                textAlign: TextAlign.justify)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.pin_drop)),
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: matchData.distance!.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: " km away")
            ]))
          ]),
          IconButton(
              icon: const Icon(Icons.waving_hand_rounded), onPressed: () {})
        ])
      ]));

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
      children: _matchesList!.map((MatchData data) => _match(data)).toList());

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
