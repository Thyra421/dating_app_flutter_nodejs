import 'package:app/theme.dart';
import 'package:flutter/material.dart';

import '../global/format.dart';

class ProfileItemCard extends StatefulWidget {
  const ProfileItemCard({
    super.key,
    required this.item,
    required this.onRemoveItem,
    required this.onEditItem,
    required this.itemsList,
  });
  final String item;
  final void Function() onRemoveItem;
  final void Function(String newValue) onEditItem;
  final List<String> itemsList;

  @override
  State<ProfileItemCard> createState() => _ProfileItemCardState();
}

class _ProfileItemCardState extends State<ProfileItemCard> {
  late String _item;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEditMode = false;

  void _onEditValue() {
    if (!_formKey.currentState!.validate()) return;
    widget.onEditItem(_controller.text);
    setState(() => _item = _controller.text);
    _toggleEditMode();
  }

  String? _onValidate(String? value) {
    value = formatItem(value ?? "");
    if (value.isEmpty) return "Please enter at least one character";
    if (value != _item && widget.itemsList.contains(value))
      return "$value is already in your list.";
    return null;
  }

  void _toggleEditMode() => setState(() => _isEditMode = !_isEditMode);

  String _getInitials() {
    List<String> words = _item.split(' ');
    String initials = '';
    for (int i = 0; i < words.length.clamp(0, 2); i++) initials += words[i][0];
    return initials;
  }

  Widget _itemImage() => Container(
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: kThemeColor),
      height: 50,
      width: 50,
      child: Center(
          child: Text(_getInitials(),
              style: const TextStyle(fontWeight: FontWeight.bold))));

  Widget _removeButton() =>
      IconButton(icon: const Icon(Icons.close), onPressed: widget.onRemoveItem);

  Widget _editButton() =>
      IconButton(icon: const Icon(Icons.check), onPressed: _onEditValue);

  Widget _itemName() =>
      Padding(padding: const EdgeInsets.only(left: 10), child: Text(_item));

  Widget _editField() => Form(
      key: _formKey,
      child: TextFormField(
        controller: _controller,
        validator: _onValidate,
        autofocus: true,
        decoration: InputDecoration(hintText: widget.item),
        maxLength: 30,
        textCapitalization: TextCapitalization.sentences,
      ));

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _controller.text = widget.item;
  }

  @override
  Widget build(BuildContext context) => ListTile(
      onTap: _toggleEditMode,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: _isEditMode ? _editField() : _itemName(),
      leading: _isEditMode ? null : _itemImage(),
      trailing: _isEditMode ? _editButton() : _removeButton());
}
