import 'package:lust/data/steps_data.dart';
import 'package:lust/global/api.dart';
import 'package:lust/global/navigation.dart';
import 'package:lust/theme.dart';
import 'package:flutter/material.dart';

import '../data/error_data.dart';
import '../global/format.dart';
import '../global/messenger.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await Api.login(
          mail: _mailController.text, password: _passwordController.text);
      StepsData steps = await Api.getSteps();
      if (!steps.identity!) return Navigation.identity(replace: true);
      if (!steps.gettingStarted!)
        return Navigation.gettingStarted(replace: true);
      return Navigation.home(replace: true);
    } on ErrorData catch (e) {
      Messenger.showSnackBar(e.value!);
    } catch (e) {}
  }

  void _toggleObscureText() => setState(() => _obscureText = !_obscureText);

  Widget _image() =>
      SizedBox(height: 300, child: Image.asset("assets/images/lust.png"));

  Widget _mailField() => formatFullRow(
          child: TextFormField(
        controller: _mailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(hintText: "Mail"),
        validator: (s) => (s ?? "").isEmpty ? "Please enter your mail" : null,
      ));

  Widget _passwordField() => formatFullRow(
          child: TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
            hintText: "Password",
            suffixIcon: TextButton(
                onPressed: _toggleObscureText,
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                        _obscureText ? Colors.grey : kThemeColor)),
                child: const Icon(Icons.remove_red_eye_rounded))),
        obscureText: _obscureText,
        validator: (s) =>
            (s ?? "").isEmpty ? "Please enter your password" : null,
      ));

  Widget _submitButton() => formatFullRow(
      child: ElevatedButton(
          onPressed: _onSubmit,
          child: const Text("Sign in",
              style: TextStyle(fontWeight: FontWeight.bold))));

  Widget _or() => const Divider(
      indent: kHorizontalPadding, endIndent: kHorizontalPadding, thickness: 1);

  Widget _googleButton() => formatFullRow(
        child: ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            child: Row(children: [
              Image.asset("assets/images/google_logo.png", height: 30),
              const Expanded(
                child: Center(
                  child: Text("Continue with Google",
                      style: TextStyle(color: Colors.black)),
                ),
              )
            ])),
      );

  Widget _facebookButton() => formatFullRow(
        child: ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            child: Row(children: [
              Image.asset("assets/images/facebook_logo.png", height: 30),
              const Expanded(
                  child: Center(
                      child: Text("Continue with Facebook",
                          style: TextStyle(color: Colors.black))))
            ])),
      );

  Widget _notAMember() =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("Not a member?",
            style: TextStyle(fontWeight: FontWeight.bold)),
        TextButton(
            onPressed: () => Navigation.register(replace: true),
            child: const Text("Register",
                style: TextStyle(fontWeight: FontWeight.bold)))
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _image(),
              _mailField(),
              _passwordField(),
              _submitButton(),
              _or(),
              _googleButton(),
              _facebookButton(),
              _notAMember(),
            ],
          ),
        ),
      ),
    );
  }
}
