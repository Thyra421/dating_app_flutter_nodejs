import 'package:lust/data/error_data.dart';
import 'package:lust/data/identity_data.dart';
import 'package:lust/data/steps_data.dart';
import 'package:lust/global/format.dart';
import 'package:lust/global/messenger.dart';
import 'package:lust/global/navigation.dart';
import 'package:lust/utils/dropdown_list.dart';
import 'package:flutter/cupertino.dart';
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
  // final TextEditingController _dateOfBirthController = TextEditingController();
  GenderData? _gender;
  DateTime _dateOfBirth = DateTime(2000, 1, 1);

  void _onClickNext() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await Api.setIdentity(IdentityData(
          firstName: _firstNameController.text,
          gender: _gender,
          // dateOfBirth: DateTime.parse(_dateOfBirthController.text))
          dateOfBirth: _dateOfBirth));
      await Api.setSteps(StepsData(identity: true));
      Navigation.gettingStarted(replace: true);
    } on ErrorData catch (e) {
      Messenger.showSnackBar(e.value!);
    } catch (e) {
      Messenger.showSnackBar("Failed $e");
    }
  }

  Widget _firstName() => formatFullRow(
      child: TextFormField(
          controller: _firstNameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: "First name"),
          validator: (String? value) =>
              (value ?? "").isEmpty ? "Please enter your first name" : null));

  Widget _genderDropdown() => FormField<GenderData>(
      validator: ((GenderData? value) =>
          value == null ? "Please select your gender" : null),
      builder: (FormFieldState<GenderData> s) => DropdownList<GenderData>(
          choices: GenderData.values
              .map((gender) =>
                  DropdownEntry<GenderData>(formatGenderData(gender), gender))
              .toList(),
          callback: (DropdownEntry<GenderData> v) {
            _gender = v.value;
            s.didChange(v.value);
          },
          hint: "Gender",
          error: s.errorText));

  Widget _datePicker() => formatFullRow(
      child: SizedBox(
          height: 100,
          child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _dateOfBirth,
              onDateTimeChanged: (DateTime newDateTime) =>
                  _dateOfBirth = newDateTime)));

  // Widget _dateOfBirth() => formatFullRow(
  //     child: TextFormField(
  //         controller: _dateOfBirthController,
  //         keyboardType: TextInputType.datetime,
  //         decoration: const InputDecoration(hintText: "Date of birth"),
  //         validator: (String? value) => (value ?? "").isEmpty
  //             ? "Please enter your date of birth"
  //             : null));

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
          section("Gender identity"),
          _genderDropdown(),
          section("Date of birth"),
          // _dateOfBirth(),
          _datePicker(),
          _nextButton()
        ]),
      ),
    );
  }
}
