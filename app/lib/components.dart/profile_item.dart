import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class ProfileItemCard extends StatefulWidget {
  const ProfileItemCard(this.item, this.onRemoveItem, this.onEditItem,
      {super.key});
  final String item;
  final void Function() onRemoveItem;
  final void Function(String newValue) onEditItem;

  @override
  State<ProfileItemCard> createState() => _ProfileItemCardState();
}

class _ProfileItemCardState extends State<ProfileItemCard> {
  final TextEditingController _controller = TextEditingController();
  late String _item;
  bool _isEditMode = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onEditValue() {
    if (!_formKey.currentState!.validate()) return;
    widget.onEditItem(_controller.text);
    setState(() => _item = _controller.text);
    _toggleEditMode();
  }

  void _toggleEditMode() => setState(() => _isEditMode = !_isEditMode);

  String _getInitials() {
    List<String> words = _item.split(' ');
    String initials = '';
    for (int i = 0; i < words.length.clamp(0, 2); i++) initials += words[i][0];
    return initials;
  }

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _controller.text = widget.item;
  }

  @override
  Widget build(BuildContext context) => ListTile(
      onTap: _toggleEditMode,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      title: _isEditMode
          ? Form(
              key: _formKey,
              child: TextFormField(
                  maxLength: 30,
                  controller: _controller,
                  validator: (value) => (value ?? "").isEmpty
                      ? "Please enter at least one character"
                      : null,
                  decoration: InputDecoration(hintText: widget.item)))
          : Padding(
              padding: const EdgeInsets.only(left: 10), child: Text(_item)),
      leading: _isEditMode
          ? null
          : Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: kThemeColor),
              height: 50,
              width: 50,
              child: Center(
                  child: Text(_getInitials(),
                      style: const TextStyle(fontWeight: FontWeight.bold)))),
      trailing: _isEditMode
          ? IconButton(icon: const Icon(Icons.check), onPressed: _onEditValue)
          : IconButton(
              icon: const Icon(Icons.close), onPressed: widget.onRemoveItem));
}
