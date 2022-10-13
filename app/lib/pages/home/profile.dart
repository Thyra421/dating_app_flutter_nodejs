import 'dart:math';

import 'package:app/components.dart/profile_item.dart';
import 'package:app/global/format.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    "a sport"
  ];

  void _onAddItem() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _itemsList.add(_addTextController.text));
    _addTextController.clear();
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100), curve: Curves.linear);
  }

  void _onRemoveItem(String item) => setState(() => _itemsList.remove(item));

  void _onOtherTip() => _randomId = Random().nextInt(_ideas.length);

  void _onEditItem(String oldValue, String newValue) => setState(() {
        int index = _itemsList.indexOf(oldValue);
        _itemsList[index] = newValue;
      });

  Widget _name() => Container(
        padding: const EdgeInsets.all(30),
        color: Theme.of(context).canvasColor,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Willem Rebergen",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      );

  Widget _youLike() => Container(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
        color: Theme.of(context).canvasColor,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "You like ...",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      );

  Widget _items() => Expanded(
          child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        controller: _scrollController,
        children: [
          ..._itemsList
              .map((i) => ProfileItemCard(i, () => _onRemoveItem(i),
                  (String newValue) => _onEditItem(i, newValue)))
              .toList(),
          _addingCard(),
          _noMoreIdea()
        ],
      ));

  Widget _addingCard() => ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: Form(
          key: _formKey,
          child: TextFormField(
              controller: _addTextController,
              decoration:
                  const InputDecoration(hintText: "What else do you like?"),
              validator: (String? value) => (value ?? "").isEmpty
                  ? "Enter at least one character"
                  : null)),
      trailing:
          IconButton(icon: const Icon(Icons.check), onPressed: _onAddItem));

  Widget _noMoreIdea() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
              padding: EdgeInsets.all(20), child: Icon(Icons.tips_and_updates)),
          Text.rich(TextSpan(children: [
            const TextSpan(text: "No more idea? "),
            const TextSpan(text: "Try adding "),
            TextSpan(
                text: "${_ideas[_randomId]}.",
                style: const TextStyle(fontWeight: FontWeight.bold))
          ])),
          TextButton(
            onPressed: () => setState(() => _onOtherTip()),
            child: const Text("Other tip",
                style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      );

  @override
  void initState() {
    super.initState();
    _onOtherTip();
  }

  @override
  Widget build(BuildContext context) =>
      Column(children: [_name(), _youLike(), _items()]);
}
