import 'package:lust/data/identity_data.dart';
import 'package:lust/theme.dart';
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

String formatGenderData(GenderData genderData) {
  String raw = genderData.name;
  String result = "";

  for (int i = 0; i < raw.length; i++) {
    if (raw[i].compareTo('A') >= 0 && raw[i].compareTo('Z') <= 0)
      result += " ${raw[i].toLowerCase()}";
    else
      result += raw[i];
  }
  result = result.replaceRange(0, 1, result[0].toUpperCase());
  return result;
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

InputDecoration editField() => InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    filled: true,
    fillColor: kBackgroundColor,
    floatingLabelStyle: const TextStyle(color: kThemeColor),
    labelStyle: const TextStyle(color: Colors.grey),
    hintStyle: const TextStyle(color: Colors.grey),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade700)),
    errorBorder:
        const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    focusedErrorBorder:
        const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)));
