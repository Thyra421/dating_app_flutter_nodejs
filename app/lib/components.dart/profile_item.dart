import 'package:lust/theme.dart';
import 'package:flutter/material.dart';

import '../global/format.dart';

class ProfileItem extends StatefulWidget {
  const ProfileItem({
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
  State<ProfileItem> createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  late String _item;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEditMode = false;
  final FocusNode _focusNodeEdit = FocusNode();

  void _onEditValue() {
    if (!_formKey.currentState!.validate()) return;
    widget.onEditItem(_controller.text);
    setState(() {
      _item = _controller.text;
      _isEditMode = false;
    });
  }

  String? _onValidate(String? value) {
    value = formatItem(value ?? "");
    if (value.isEmpty) return "Please enter at least one character";
    if (value != _item && widget.itemsList.contains(value))
      return "$value is already in your list.";
    return null;
  }

  void _onTap() {
    setState(() => _isEditMode = true);
    _focusNodeEdit.requestFocus();
  }

  void _focusListener() {
    if (!_focusNodeEdit.hasPrimaryFocus) setState(() => _isEditMode = false);
  }

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
      Padding(padding: const EdgeInsets.only(left: 20), child: Text(_item));

  Widget _editField() => Form(
      key: _formKey,
      child: TextFormField(
        focusNode: _focusNodeEdit,
        controller: _controller,
        validator: _onValidate,
        decoration: editField().copyWith(hintText: widget.item),
        maxLength: 30,
        textCapitalization: TextCapitalization.sentences,
      ));

  @override
  void dispose() {
    super.dispose();
    _focusNodeEdit.removeListener(_focusListener);
    _focusNodeEdit.dispose();
  }

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _controller.text = widget.item;
    _focusNodeEdit.addListener(_focusListener);
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: _onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kHorizontalPadding, vertical: 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            if (!_isEditMode) _itemImage(),
            Expanded(child: _isEditMode ? _editField() : _itemName()),
            _isEditMode ? _editButton() : _removeButton()
          ]),
        ),
      );
}
