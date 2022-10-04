import 'package:flutter/material.dart';

Widget formatButtonFullRow(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    child: SizedBox(height: 50, child: Expanded(child: child)));

Widget formatField(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 50),
        child: Expanded(child: child)));
