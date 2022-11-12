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

import '../../global/format.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  MatchData? _matchData;
  bool? _hasEnabledLocation;
  bool _loading = false;
  LocationData _locationData = LocationData();
  late TabController _controller;
  bool _showDescription = true;

  void _onShowActionsModal() => showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      context: context,
      builder: (context) => modal(
          context,
          "Report",
          Column(children: [
            TextButton(
                onPressed: () {},
                child: Text("Report ${_matchData!.matchIdentity!.firstName}")),
            TextButton(
                onPressed: () {},
                child: Text("Block ${_matchData!.matchIdentity!.firstName}")),
            TextButton(onPressed: () {}, child: const Text("Contact us"))
          ])));

  void _onPressSearch() async {
    setState(() => _loading = true);
    if (!await _onGetLocation()) {
      setState(() => _loading = false);
      return;
    }
    await _onSearch();
    setState(() => _loading = false);
  }

  void _onChangeTab() => setState(() {});

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
      setState(() {
        if (matchData.noMatch == null || !matchData.noMatch!)
          _controller = TabController(
              length: matchData.pictures!.pictures!.length, vsync: this);
        _controller.addListener(_onChangeTab); // for indicator
        _matchData = matchData;
      });
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

  Widget _picture(String url) => ShaderMask(
      shaderCallback: (rect) => LinearGradient(
            begin: const Alignment(0, .5),
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              _showDescription ? Colors.transparent : Colors.black
            ],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height)),
      blendMode: BlendMode.dstIn,
      child: Image.network(url,
          fit: _showDescription ? BoxFit.cover : BoxFit.contain,
          loadingBuilder: imageLoader));

  List<Widget> _picturesList() =>
      _matchData!.pictures!.pictures!.map((p) => _picture(p.url!)).toList();

  Widget _pictures() =>
      TabBarView(controller: _controller, children: _picturesList());

  Widget _description() => Text(_matchData!.matchIdentity!.description!,
      textAlign: TextAlign.justify);

  Widget _hobbiesInCommon() => Text.rich(TextSpan(children: [
        TextSpan(
            text: _matchData!.commonHobbiesCount!.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: " hobbies in common")
      ]));

  Widget _distance() => Text.rich(TextSpan(children: [
        TextSpan(
            text: _matchData!.distance!.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: " km away")
      ]));

  Widget _likeButton() => ElevatedButton(
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(50, 50)),
          shape: MaterialStateProperty.all(const CircleBorder())),
      onPressed: () {},
      child: const Icon(Icons.favorite));

  Widget _notInterestedButton() => ElevatedButton(
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(50, 50)),
          shape: MaterialStateProperty.all(const CircleBorder())),
      onPressed: _onNotInterested,
      child: const Icon(Icons.close));

  Widget _pictureNavigation() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          _matchData!.pictures!.pictures!.length,
          (index) => Icon(Icons.circle,
              size: 8,
              color: index == _controller.index ? kThemeColor : Colors.white)));

  Widget _optionsButton() => IconButton(
      onPressed: _onShowActionsModal, icon: const Icon(Icons.flag_circle));

  void _toggleShowDescriptions() =>
      setState(() => _showDescription = !_showDescription);

  Widget _match() => Container(
      child: _matchData!.noMatch ?? false
          ? _noOneInSight()
          : Stack(children: [
              InkWell(
                  onTap: _toggleShowDescriptions,
                  child: FractionallySizedBox(
                      heightFactor: _showDescription ? .8 : 1,
                      child: _pictures())),
              Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _pictureNavigation()),
              Align(alignment: Alignment.topRight, child: _optionsButton()),
              AnimatedOpacity(
                  opacity: _showDescription ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(kHorizontalPadding),
                            child: _name()),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kHorizontalPadding),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [_hobbiesInCommon(), _distance()])),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: kHorizontalPadding,
                                horizontal: kHorizontalPadding),
                            child: _description()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: kHorizontalPadding),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _notInterestedButton(),
                                _likeButton()
                              ]),
                        )
                      ]))
            ]));

  Widget _searchButton() => Center(
      child: IconButton(icon: const Icon(Icons.search), onPressed: _onSearch));

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
    _controller.removeListener(_onChangeTab);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onPressSearch();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _search();
  }
}
