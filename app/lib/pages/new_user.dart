import 'package:app/global/format.dart';
import 'package:app/theme.dart';
import 'package:app/utils/dropdown_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewUserPage extends StatefulWidget {
  const NewUserPage({super.key});

  @override
  State<NewUserPage> createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _section(String name) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)));

  Widget _name() => formatFullRow(
      child: TextFormField(
          decoration: const InputDecoration(hintText: "Name"),
          validator: (String? value) =>
              (value ?? "").isEmpty ? "Please enter your name" : null));

  Widget _genderDropdown() => DropdownList(choices: const [
        "Male",
        "Female",
        "Non binary",
        "Other",
        "Prefere not to say"
      ], callback: (v) {}, hint: "Gender");

  Widget _dateOfBirth() => formatFullRow(
      child: TextFormField(
          keyboardType: TextInputType.datetime,
          decoration: const InputDecoration(hintText: "Date of birth"),
          validator: (String? value) => (value ?? "").isEmpty
              ? "Please enter your date of birth"
              : null));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView(children: [
          _section("Name"),
          _name(),
          _section("Gender"),
          _genderDropdown(),
          _section("Date of birth"),
          _dateOfBirth()
        ]),
      ),
    );
  }
}
