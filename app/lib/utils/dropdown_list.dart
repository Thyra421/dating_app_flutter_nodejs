import 'package:app/global/format.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class DropdownEntry<T> {
  final String key;
  final T value;

  DropdownEntry(this.key, this.value);
}

class DropdownList<T> extends StatefulWidget {
  const DropdownList({
    super.key,
    required this.choices,
    required this.callback,
    this.isMultiple = false,
    this.initialValue,
    this.hint,
    this.error,
  });

  final List<DropdownEntry<T>> choices;
  final String? hint;
  final bool isMultiple;
  final DropdownEntry<T>? initialValue;
  final void Function(DropdownEntry<T> value) callback;
  final String? error;

  @override
  State<DropdownList<T>> createState() => _DropdownListState<T>();
}

class _DropdownListState<T> extends State<DropdownList<T>> {
  DropdownEntry<T>? _selectedValue;
  bool _isExpanded = false;

  void _toggleExpanded() => setState(() => _isExpanded = !_isExpanded);

  void _setValue(DropdownEntry<T> value) => setState(() {
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
                  ? Text(_selectedValue!.key,
                      style: Theme.of(context).textTheme.subtitle1)
                  : null)));

  Widget _choice(DropdownEntry<T> choice) => InkWell(
      onTap: () => _setValue(choice),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child:
              Text(choice.key, style: Theme.of(context).textTheme.subtitle1)));

  Widget _choices() => AnimatedSize(
      duration: const Duration(milliseconds: 100),
      alignment: Alignment.topCenter,
      child: _isExpanded
          ? Container(
              constraints: const BoxConstraints(maxHeight: 250),
              margin:
                  const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
              decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(kBorderRadius)),
              child: ListView(
                  shrinkWrap: true,
                  children: widget.choices
                      .map((DropdownEntry<T> c) => _choice(c))
                      .toList()))
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
