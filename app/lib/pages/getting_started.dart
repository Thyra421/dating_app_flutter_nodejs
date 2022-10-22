import 'package:app/global/api.dart';
import 'package:app/global/format.dart';
import 'package:app/global/navigation.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class GettingStartedPage extends StatefulWidget {
  const GettingStartedPage({super.key});

  @override
  State<GettingStartedPage> createState() => _GettingStartedPageState();
}

class _GettingStartedPageState extends State<GettingStartedPage> {
  void _onClickDone() async {
    await Api.setSteps(gettingStarted: true);
    Navigation.home(replace: true);
  }

  void _onClickSkip() async {
    await Api.setSteps(gettingStarted: true);
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
                children: items.map((item) => _itemCard(item)).toList())),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(automaticallyImplyLeading: false, actions: [_skipButton()]),
      body: ListView(children: [
        title("Getting started"),
        section("Select items you like"),
        subtitle("You can always change your choices later"),
        section("Movie"),
        _itemsGrid([
          "Star Wars",
          "La La Land",
          "Inception",
          "Scooby-Doo",
          "Harry Potter",
          "The Godfather",
          "Finding Nemo",
          "Fight Club",
          "The Matrix",
        ]),
        section("Music"),
        _itemsGrid([
          "Queen",
          "Sefa",
          "Michael Jackson",
          "Bob Marley",
          "Kanye West",
          "Rihanna",
        ]),
        section("Food"),
        _itemsGrid([
          "Pasta",
          "Soup",
          "Tomato",
          "Cereals",
          "Pizza",
        ]),
        _doneButton()
      ]),
    );
  }
}
