import 'package:flutter/material.dart';
import 'package:lust/global/format.dart';

class ProfileDescription extends StatefulWidget {
  const ProfileDescription({
    super.key,
    required this.description,
    required this.onChange,
  });

  final String description;
  final void Function(String desc) onChange;

  @override
  State<ProfileDescription> createState() => _ProfileDescriptionState();
}

class _ProfileDescriptionState extends State<ProfileDescription> {
  final TextEditingController _descriptionController = TextEditingController();
  late String _description;
  final FocusNode _editorFocusNode = FocusNode();
  final FocusNode _buttonFocusNode = FocusNode();
  bool _editDescription = false;

  void _onTap() {
    setState(() => _editDescription = true);
    _editorFocusNode.requestFocus();
  }

  void _focusListener() {
    if (!_editorFocusNode.hasPrimaryFocus && !_buttonFocusNode.hasPrimaryFocus)
      setState(() => _editDescription = false);
  }

  void _onSave() {
    widget.onChange(_descriptionController.text);
    setState(() {
      _description = _descriptionController.text;
      _editDescription = false;
    });
  }

  @override
  void dispose() {
    _editorFocusNode.removeListener(_focusListener);
    _editorFocusNode.dispose();
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _description = widget.description;
    _editorFocusNode.addListener(_focusListener);
    _descriptionController.text = widget.description;
  }

  Widget _editor() => Row(children: [
        Expanded(
            child: TextField(
          focusNode: _editorFocusNode,
          decoration: editField().copyWith(hintText: "Description"),
          controller: _descriptionController,
          maxLines: null,
        )),
        IconButton(
          focusNode: _buttonFocusNode,
          onPressed: _onSave,
          icon: const Icon(Icons.check),
        )
      ]);

  Widget _text() => InkWell(
        onTap: _onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: _description.isEmpty
              ? const Text("Tap to edit your description",
                  style: TextStyle(color: Colors.grey))
              : Text(_description, textAlign: TextAlign.justify),
        ),
      );

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: _editDescription ? _editor() : _text());
}
