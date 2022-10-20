import 'package:app/theme.dart';
import 'package:flutter/material.dart';

Widget formatFullRow({required Widget child}) => Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: kHorizontalPadding, vertical: 10),
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

Widget section(String name) => Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: kHorizontalPadding, vertical: 10),
    child: Text(name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)));

Widget title(String name) => Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: kHorizontalPadding, vertical: 10),
    child: Text(name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)));

Widget subtitle(String text) => Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: kHorizontalPadding, vertical: 10),
    child: Text(text, style: const TextStyle(fontSize: 16)));
