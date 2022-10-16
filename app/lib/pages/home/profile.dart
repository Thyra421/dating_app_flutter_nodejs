import 'dart:math';

import 'package:app/components.dart/profile_item.dart';
import 'package:app/global/format.dart';
import 'package:app/global/navigation.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _addTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late int _randomId;

  List<String> _itemsList = [
    "Star Wars",
    "Party",
    "Pizza",
    "Reading",
    "The Rock",
  ];

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

  void _onAddItem() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _itemsList.add(formatItem(_addTextController.text)));
    _addTextController.clear();
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
  }

  void _onRemoveItem(String item) => setState(() => _itemsList.remove(item));

  void _onOtherTip() => _randomId = Random().nextInt(_ideas.length);

  void _onEditItem(String oldValue, String newValue) => setState(() {
        int index = _itemsList.indexOf(oldValue);
        _itemsList[index] = formatItem(newValue);
      });

  String? _onValidate(String? value) {
    value = formatItem(value ?? "");
    if (value.isEmpty) return "Please enter at least one character";
    if (_itemsList.contains(value)) return "$value is already in your list.";
    return null;
  }

  Widget _name() => Container(
        padding: const EdgeInsets.only(
          left: 30,
          top: 30,
          bottom: 30,
          right: 10,
        ),
        child: Row(
          children: [
            Container(
                height: 70,
                width: 70,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: const Icon(Icons.person, color: Colors.black, size: 40)),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Willem Rebergen",
                    textAlign: TextAlign.end,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              ),
            ),
            IconButton(
                iconSize: 30,
                onPressed: () => Navigation.settings(),
                icon: const Icon(Icons.settings))
          ],
        ),
      );

  Widget _youLike() => Container(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
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
          .map((String i) => ProfileItemCard(
              key: UniqueKey(),
              item: i,
              onRemoveItem: () => _onRemoveItem(i),
              onEditItem: (String newValue) => _onEditItem(i, newValue),
              itemsList: _itemsList))
          .toList());

  Widget _addingCard() => ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      title: Form(
          key: _formKey,
          child: TextFormField(
            controller: _addTextController,
            validator: _onValidate,
            decoration:
                const InputDecoration(hintText: "What else do you like?"),
            maxLength: 30,
            textCapitalization: TextCapitalization.sentences,
          )),
      trailing:
          IconButton(icon: const Icon(Icons.check), onPressed: _onAddItem));

  Widget _noMoreIdea() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.tips_and_updates)),
          Expanded(
            child: Text.rich(TextSpan(children: [
              const TextSpan(text: "No more idea? "),
              const TextSpan(text: "Try adding "),
              TextSpan(
                  text: _ideas[_randomId],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: " you like.")
            ])),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
      _name(),
      _youLike(),
      Expanded(
          child: ListView(
        padding: const EdgeInsets.only(bottom: 30),
        controller: _scrollController,
        children: [
          _items(),
          _addingCard(),
          _noMoreIdea(),
        ],
      ))
    ]);
  }
}
