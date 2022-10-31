import 'package:lust/data/steps_data.dart';
import 'package:lust/global/api.dart';
import 'package:lust/global/format.dart';
import 'package:lust/global/navigation.dart';
import 'package:lust/theme.dart';
import 'package:flutter/material.dart';

class GettingStartedPage extends StatefulWidget {
  const GettingStartedPage({super.key});

  @override
  State<GettingStartedPage> createState() => _GettingStartedPageState();
}

class _GettingStartedPageState extends State<GettingStartedPage> {
  void _onClickDone() {
    Api.setSteps(StepsData(gettingStarted: true));
    Navigation.home(replace: true);
  }

  void _onClickSkip() {
    Api.setSteps(StepsData(gettingStarted: true));
    Navigation.home(replace: true);
  }

  Widget _doneButton() => formatFullRow(
      child:
          ElevatedButton(onPressed: _onClickDone, child: const Text("Done")));

  Widget _skipButton() => Center(
      child: TextButton(onPressed: _onClickSkip, child: const Text("Skip")));

  Widget _itemCard(String item) => Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: kThemeColor,
          borderRadius: BorderRadius.circular(kBorderRadius)),
      child: Text(item, textAlign: TextAlign.center));

  Widget _itemsGrid(List<String> items) => Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 100),
          child: GridView.count(
              padding:
                  const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              scrollDirection: Axis.horizontal,
              crossAxisCount: 1,
              children: items.map((item) => _itemCard(item)).toList())));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(automaticallyImplyLeading: false, actions: [_skipButton()]),
        body: ListView(children: [
          title("Getting started"),
          section("Select items you like"),
          subtitle("You can always change your choices later"),
          section("Movie genre"),
          _itemsGrid([
            "Action",
            "Thriller",
            "Comedy",
            "Drama",
            "Romance",
            "Adventure",
            "Horror",
            "Science Fiction",
            "Adventure",
          ]),
          section("Music genre"),
          _itemsGrid([
            "Rap",
            "Pop",
            "Rock",
            "Reggae",
            "Metal",
            "Electronic",
            "Latin",
            "Classic",
            "R&B",
            "Hardcore",
            "Jazz",
            "Blues",
            "Country",
            "Folk",
          ]),
          section("Activity"),
          _itemsGrid([
            "Sport",
            "Reading",
            "Shopping",
            "Video Games",
            "Travel",
            "Dance",
            "Cooking",
            "Board games",
            "DIY",
          ]),
          _doneButton()
        ]));
  }
}
