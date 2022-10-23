import 'dart:math';
import 'package:app/components.dart/profile_description.dart';
import 'package:app/components.dart/profile_item.dart';
import 'package:app/global/api.dart';
import 'package:app/global/format.dart';
import 'package:app/global/navigation.dart';
import 'package:app/theme.dart';
import 'package:app/utils/future_widget.dart';
import 'package:flutter/material.dart';

import '../../components.dart/add_profile_item.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  late int _randomTipId;

  String _firstName = "";
  String _lastName = "";
  String _description = "";
  List<String> _itemsList = [];

  static const List<String> _ideas = [
    "a movie",
    "a singer",
    "a food",
    "a place",
    "a show",
    "a song",
    "a book",
    "a drink",
    "an animal",
    "a music genre",
    "a sport",
    "a game",
    "a music instrument"
  ];

  void _onAddItem(String item) {
    setState(() => _itemsList.add(formatItem(item)));
    Api.setHobbies(_itemsList);
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
  }

  void _onRemoveItem(String item) {
    setState(() => _itemsList.remove(item));
    Api.setHobbies(_itemsList);
  }

  void _onEditItem(String oldValue, String newValue) {
    int index = _itemsList.indexOf(oldValue);
    _itemsList[index] = formatItem(newValue);
    Api.setHobbies(_itemsList);
  }

  void _onEditDescription(String value) {
    Api.setIdentity(description: value);
  }

  void _onOtherTip() => _randomTipId = Random().nextInt(_ideas.length);

  void _getItemsList(List<String> itemsList) => setState(() {
        _itemsList = itemsList;
      });

  void _getIdentity(Map<String, dynamic> identity) => setState(() {
        _firstName = identity['firstName'];
        _lastName = identity['lastName'];
        _description = identity['description'];
      });

  Expanded _name() => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text.rich(
              TextSpan(children: [
                TextSpan(text: "$_firstName "),
                TextSpan(text: _lastName)
              ]),
              textAlign: TextAlign.end,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ),
      );

  IconButton _settingsButton() => IconButton(
      iconSize: 30,
      onPressed: () => Navigation.settings(),
      icon: const Icon(Icons.settings));

  Container _profilePicture() => Container(
      height: 70,
      width: 70,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: const Icon(Icons.person, color: Colors.black, size: 40));

  Widget _identity() => Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
              padding: const EdgeInsets.only(
                  left: kHorizontalPadding, right: kHorizontalPadding),
              child: Row(
                  children: [_profilePicture(), _name(), _settingsButton()])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            child: ProfileDescription(
                description: _description, onChange: _onEditDescription),
          )
        ],
      ));

  Widget _youLike() => Container(
        padding: const EdgeInsets.only(
            left: kHorizontalPadding, right: kHorizontalPadding, bottom: 20),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "You like ${_itemsList.length} items",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      );

  Widget _items() => Column(
      mainAxisSize: MainAxisSize.min,
      children: _itemsList
          .map((String i) => ProfileItem(
              key: UniqueKey(),
              item: i,
              onRemoveItem: () => _onRemoveItem(i),
              onEditItem: (String newValue) => _onEditItem(i, newValue),
              itemsList: _itemsList))
          .toList());

  Widget _noMoreIdea() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
              child: Icon(Icons.tips_and_updates)),
          Expanded(
            child: Text.rich(TextSpan(children: [
              const TextSpan(text: "No more idea? "),
              const TextSpan(text: "Try adding "),
              TextSpan(
                  text: _ideas[_randomTipId],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: " you like.")
            ])),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            child: TextButton(
              onPressed: () => setState(() => _onOtherTip()),
              child: const Text("Other tip",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _onOtherTip();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(children: [
      FutureWidget(
          future: () => Api.getIdentity()..then(_getIdentity, onError: (_) {}),
          widget: _identity()),
      _youLike(),
      FutureWidget(
          future: () => Api.getHobbies()..then(_getItemsList, onError: (_) {}),
          widget: Expanded(
              child: ListView(
            padding: const EdgeInsets.only(bottom: 30),
            controller: _scrollController,
            children: [
              _items(),
              AddProfileItem(onAddItem: _onAddItem, itemsList: _itemsList),
              _noMoreIdea(),
            ],
          )))
    ]);
  }
}
