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
    this.error,
  });

  final List<String> choices;
  final String? hint;
  final bool isMultiple;
  final String? initialValue;
  final void Function(String value) callback;
  final String? error;

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  String? _selectedValue;
  bool _isExpanded = false;

  void _toggleExpanded() => setState(() => _isExpanded = !_isExpanded);

  void _setValue(String value) => setState(() {
        _selectedValue = value;
        widget.callback(value);
        _isExpanded = !_isExpanded;
      });

  Widget _field() => formatFullRow(
      child: InkWell(
          onTap: _toggleExpanded,
          child: InputDecorator(
              isEmpty: _selectedValue == null,
              decoration: InputDecoration(
                  errorText: widget.error,
                  hintText: widget.hint,
                  suffixIcon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.black)),
              child: _selectedValue != null
                  ? Text(_selectedValue!,
                      style: Theme.of(context).textTheme.subtitle1)
                  : null)));

  Widget _choice(String choice) => InkWell(
      onTap: () => _setValue(choice),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(choice, style: Theme.of(context).textTheme.subtitle1)));

  Widget _choices() => AnimatedSize(
      duration: const Duration(milliseconds: 100),
      alignment: Alignment.topCenter,
      child: _isExpanded
          ? Container(
              constraints: const BoxConstraints(maxHeight: 250),
              margin:
                  const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kBorderRadius)),
              child: ListView(
                  shrinkWrap: true,
                  children: widget.choices.map((c) => _choice(c)).toList()))
          : Container());

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) =>
      Column(children: [_field(), _choices()]);
}
