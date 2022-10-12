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

  Widget _item(int index, String content) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        key: Key(content),
        title: Text(content),
        trailing: ReorderableDragStartListener(
            index: index, child: const Icon(Icons.drag_handle)),
      );

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _name(),
          Expanded(
            child: ReorderableListView(
                buildDefaultDragHandles: false,
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) newIndex -= 1;

                    final String old = _items.removeAt(oldIndex);
                    _items.insert(newIndex, old);
                  });
                },
                children: _items
                    .asMap()
                    .entries
                    .map((e) => _item(e.key, e.value))
                    .toList()),
          )
        ],
      );
}
