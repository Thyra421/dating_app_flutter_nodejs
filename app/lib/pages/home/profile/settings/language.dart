import 'package:flutter/material.dart';

import '../../../../global/navigation.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  static const List<String> _languages = [
    "Français FR",
    "Français QC",
    "English US",
    "English UK",
    "Español ES",
    "中文 ZH",
    "Русский RU",
    "Italiano IT"
  ];

  Widget _language(String language) => InkWell(
      onTap: () => Navigation.pop(language),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
              height: 60,
              alignment: Alignment.centerLeft,
              child: Text(language))));

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: ListView(children: _languages.map((l) => _language(l)).toList()));
}
