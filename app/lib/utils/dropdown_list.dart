import 'package:app/global/format.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class DropdownList extends StatefulWidget {
  const DropdownList({
    super.key,
    required this.choices,
    required this.callback,
    this.isMultiple = false,
    this.initialValue,
    this.hint,
  });

  final List<String> choices;
  final String? hint;
  final bool isMultiple;
  final String? initialValue;
  final void Function(String value) callback;

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  String? _selectedValue;
  bool _isExpanded = false;

  void _toggleExpanded() => setState(() => _isExpanded = !_isExpanded);

  void _setValue(String value) => setState(() {
        _selectedValue = value;
        _isExpanded = !_isExpanded;
      });

  Widget _field() => formatFullRow(
          child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kBorderRadius)),
        child: InkWell(
          onTap: _toggleExpanded,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedValue ?? widget.hint ?? "",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: _selectedValue == null
                              ? Theme.of(context).hintColor
                              : Colors.black)),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.black)
                ],
              ),
            ),
          ),
        ),
      ));

  Widget _choice(String choice) => InkWell(
      onTap: () => _setValue(choice),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Text(choice, style: Theme.of(context).textTheme.subtitle1)));

  Widget _choices() => Container(
      constraints: const BoxConstraints(maxHeight: 250),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kBorderRadius)),
      child: ListView(
          shrinkWrap: true,
          children: widget.choices.map((c) => _choice(c)).toList()));

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) =>
      Column(children: [_field(), if (_isExpanded) _choices()]);
}
