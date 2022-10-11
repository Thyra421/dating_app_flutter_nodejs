import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> _items = [
    "Star Wars",
    "Party",
    "Pizza",
    "Reading",
    "Barack Obama",
  ];

  Widget _name() => const Padding(
        padding: EdgeInsets.all(30),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Willem Rebergen",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      );

  Widget _item(int index, String content) => Padding(
      key: Key(content),
      padding: const EdgeInsets.all(30),
      child: ListTile(
        title: Text(content),
        trailing: ReorderableDragStartListener(
            child: Icon(Icons.drag_handle), index: index),
      ));

  @override
  Widget build(BuildContext context) => ReorderableListView(
      buildDefaultDragHandles: false,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) newIndex -= 1;

          final String old = _items.removeAt(oldIndex);
          _items.insert(newIndex, old);
        });
      },
      children:
          _items.asMap().entries.map((e) => _item(e.key, e.value)).toList());
  // return Column(
  //   children: [
  //     _name(),
  //   ],
  // );

}
