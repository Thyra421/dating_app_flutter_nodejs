import 'package:flutter/material.dart';

Widget formatButton(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    child: SizedBox(
        height: 50,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [Expanded(child: child)])));

Widget formatField(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    child: child);
