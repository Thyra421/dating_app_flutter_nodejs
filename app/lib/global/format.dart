import 'package:flutter/material.dart';

Widget formatFullRow({required Widget child}) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    child: Row(children: [
      Expanded(
          child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 50), child: child))
    ]));

String formatItem(String item) {
  item = item.trim();
  item.replaceAll(RegExp(r"\s+"), " ");
  return item;
}
