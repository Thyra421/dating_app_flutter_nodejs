import 'dart:async';

import 'package:location/location.dart' as loc;
import 'package:lust/data/location_data.dart';
import 'package:lust/data/match_data.dart';
import 'package:lust/data/relations_data.dart';
import 'package:lust/global/api.dart';
import 'package:lust/global/location.dart';
import 'package:lust/global/messenger.dart';
import 'package:lust/theme.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  MatchData? _matchData;
  bool? _hasEnabledLocation;
  // Duration _duration = const Duration(minutes: 48, seconds: 13);
  late Timer _timer;
  bool _loading = false;
  LocationData _locationData = LocationData();

  void _onPressSearch() async {
    setState(() => _loading = true);
    if (!await _onGetLocation()) {
      setState(() => _loading = false);
      return;
    }
    await _onSearch();
    setState(() => _loading = false);
  }

  Future<bool> _onGetLocation() async {
    try {
      loc.LocationData? locationData = await Location.getLocation();
      _locationData = LocationData(
          posX: locationData.longitude, posY: locationData.latitude);
      await Api.setLocation(_locationData);
      setState(() => _hasEnabledLocation = true);
      return true;
    } catch (_) {
      setState(() => _hasEnabledLocation = false);
      return false;
    }
  }

  Future<void> _onSearch() async {
    try {
      MatchData matchData = await Api.search();
      setState(() => _matchData = matchData);
    } catch (e) {
      Messenger.showSnackBar("Something went wrong");
    }
  }

  void _onNotInterested() async {
    await Api.addRelations(RelationsData(notInterested: [_matchData!.userId!]));
    _onSearch();
  }

  String _getAge(DateTime dateOfBirth) =>
      (dateOfBirth.difference(DateTime.now()).inDays / 365)
          .floor()
          .abs()
          .toString();

  Widget _name() => Text.rich(TextSpan(
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          children: [
            TextSpan(text: "${_matchData!.matchIdentity!.firstName!}, "),
            TextSpan(text: _getAge(_matchData!.matchIdentity!.dateOfBirth!))
          ]));

  Widget _picture() => ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment(0, .8),
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.transparent],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: Image.network(_matchData!.pictures!.pictures![0].url!,
          fit: BoxFit.fitHeight));

  Widget _description() => Text(_matchData!.matchIdentity!.description!,
      textAlign: TextAlign.justify);

  Widget _hobbiesInCommon() => Text.rich(TextSpan(children: [
        const TextSpan(text: "You have "),
        TextSpan(
            text: _matchData!.commonHobbiesCount!.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: " hobbies in common")
      ]));

  Widget _distance() => Text.rich(TextSpan(children: [
        const TextSpan(text: "Last seen "),
        TextSpan(
            text: _matchData!.distance!.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: " km away")
      ]));

  Widget _likeButton() => ElevatedButton(
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(60, 60)),
          shape: MaterialStateProperty.all(const CircleBorder())),
      onPressed: () {},
      child: const Icon(Icons.favorite));

  Widget _match() => Container(
      // padding: const EdgeInsets.all(kHorizontalPadding),
      child: _matchData!.noMatch ?? false
          ? _noOneInSight()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                  Expanded(
                      child: Stack(fit: StackFit.expand, children: [
                    _picture(),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: const EdgeInsets.all(kHorizontalPadding),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [_name(), _distance()])))
                  ])),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: kHorizontalPadding,
                          horizontal: kHorizontalPadding),
                      child: _description()),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: kHorizontalPadding),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _hobbiesInCommon(),
                                  IconButton(
                                      onPressed: _onNotInterested,
                                      icon: const Icon(Icons.close,
                                          color: Colors.red))
                                ]),
                            _likeButton()
                          ]))
                ]));

  Widget _searchButton() => Center(
      child: IconButton(icon: const Icon(Icons.search), onPressed: _onSearch));

  // Widget _timeIndicator() => Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Text.rich(TextSpan(children: [
  //           const TextSpan(text: "Next search available in "),
  //           TextSpan(
  //               text: "${_duration.toString().split('.').first}.",
  //               style: const TextStyle(fontWeight: FontWeight.bold))
  //         ], style: const TextStyle(fontSize: 14))),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             TextButton(onPressed: () {}, child: const Text("Subscribe")),
  //             const Text("to get unlimited search.")
  //           ],
  //         ),
  //       ],
  //     );

  Widget _loadingIndicator() =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
        CircularProgressIndicator(),
        Text("Finding the best match for you...")
      ]);

  Widget _enableLocation() =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("Please allow Lust to access your location to continue"),
        TextButton(onPressed: _onPressSearch, child: const Text("OK"))
      ]);

  Widget _noOneInSight() =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("Oh no! It seems like there is no one in sight...",
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        const Text(
            "Try again later, or increase the search distance in your settings",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16)),
        _searchButton()
      ]);

  Widget _search() {
    if (_loading) return _loadingIndicator();
    if (_hasEnabledLocation != null && !_hasEnabledLocation!)
      return _enableLocation();
    if (_matchData != null) return _match();
    return Center(child: _searchButton());
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onPressSearch();
    });
    // _timer = Timer.periodic(
    //     const Duration(seconds: 1),
    //     (Timer timer) =>
    //         setState(() => _duration -= const Duration(seconds: 1)));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    print("build");
    super.build(context);
    return _search();
  }
}
