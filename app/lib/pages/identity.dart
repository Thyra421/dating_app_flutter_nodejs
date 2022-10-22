import 'package:app/global/format.dart';
import 'package:app/global/navigation.dart';
import 'package:app/utils/dropdown_list.dart';
import 'package:flutter/material.dart';

import '../global/api.dart';

class IdentityPage extends StatefulWidget {
  const IdentityPage({super.key});

  @override
  State<IdentityPage> createState() => _IdentityPageState();
}

class _IdentityPageState extends State<IdentityPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  void _onClickNext() async {
    if (_formKey.currentState!.validate()) {
      await Api.setSteps('identity', true);
      Navigation.gettingStarted(replace: true);
    }
  }

  Widget _firstName() => formatFullRow(
      child: TextFormField(
          controller: _firstNameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: "First name"),
          validator: (String? value) =>
              (value ?? "").isEmpty ? "Please enter your first name" : null));

  Widget _lastName() => formatFullRow(
      child: TextFormField(
          controller: _lastNameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: "Last name"),
          validator: (String? value) =>
              (value ?? "").isEmpty ? "Please enter your last name" : null));

  Widget _genderDropdown() => FormField<String>(
      validator: ((String? value) =>
          (value ?? "").isEmpty ? "Please select your gender" : null),
      builder: (FormFieldState<String> s) => DropdownList(
            choices: const [
              "Male",
              "Female",
              "Non binary",
              "Other",
              "Prefere not to say"
            ],
            callback: (String v) => s.didChange(v),
            hint: "Gender",
            error: s.errorText,
          ));

  Widget _dateOfBirth() => formatFullRow(
      child: TextFormField(
          controller: _dateOfBirthController,
          keyboardType: TextInputType.datetime,
          decoration: const InputDecoration(hintText: "Date of birth"),
          validator: (String? value) => (value ?? "").isEmpty
              ? "Please enter your date of birth"
              : null));

  Widget _nextButton() => formatFullRow(
      child:
          ElevatedButton(onPressed: _onClickNext, child: const Text("Next")));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Form(
        key: _formKey,
        child: ListView(children: [
          title("Identity"),
          section("Name"),
          _firstName(),
          _lastName(),
          section("Gender identity"),
          _genderDropdown(),
          section("Date of birth"),
          _dateOfBirth(),
          _nextButton()
        ]),
      ),
    );
  }
}
