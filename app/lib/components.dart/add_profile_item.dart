import 'package:flutter/material.dart';

import '../global/format.dart';
import '../theme.dart';

class AddProfileItem extends StatefulWidget {
  const AddProfileItem({
    super.key,
    required this.onAddItem,
    required this.itemsList,
  });

  final void Function(String value) onAddItem;
  final List<String> itemsList;

  @override
  State<AddProfileItem> createState() => _AddProfileItemState();
}

class _AddProfileItemState extends State<AddProfileItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _addTextController = TextEditingController();
  bool _showButton = false;

  void _onAddItem() {
    if (!_formKey.currentState!.validate()) return;
    widget.onAddItem(_addTextController.text);
    _addTextController.clear();
    setState(() => _showButton = false);
  }

  String? _onValidate(String? value) {
    value = formatItem(value ?? "");
    if (value.isEmpty) return "Please enter at least one character";
    if (widget.itemsList.contains(value))
      return "$value is already in your list.";
    return null;
  }

  void _onChanged(String? value) {
    if (!_showButton && (value ?? "").isNotEmpty)
      setState(() => _showButton = true);
    else if (_showButton && (value ?? "").isEmpty)
      setState(() => _showButton = false);
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kHorizontalPadding, vertical: 15),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Form(
              key: _formKey,
              child: Expanded(
                  child: TextFormField(
                      onChanged: _onChanged,
                      controller: _addTextController,
                      validator: _onValidate,
                      decoration: const InputDecoration(
                          hintText: "What else do you like?"),
                      maxLength: 30,
                      textCapitalization: TextCapitalization.sentences))),
          if (_showButton)
            IconButton(icon: const Icon(Icons.check), onPressed: _onAddItem)
        ]),
      );
}
