import 'package:app/global/navigation.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';

import '../global/api.dart';
import '../global/format.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePasswordText = true;
  bool _obscureConfirmPasswordText = true;

  void _onSubmit() async {
    try {
      if (!_formKey.currentState!.validate()) return;
      await Api.register(
          mail: _mailController.text, password: _passwordController.text);
      Navigation.identity(replace: true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text((e as Map<String, dynamic>)['value'])));
    }
  }

  void _toggleObscurePasswordText() =>
      setState(() => _obscurePasswordText = !_obscurePasswordText);

  void _toggleObscureConfirmPasswordText() => setState(
      () => _obscureConfirmPasswordText = !_obscureConfirmPasswordText);

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
                onPressed: _toggleObscurePasswordText,
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                        _obscurePasswordText ? Colors.grey : kThemeColor)),
                child: const Icon(Icons.remove_red_eye_rounded))),
        obscureText: _obscurePasswordText,
        validator: (s) =>
            (s ?? "").isEmpty ? "Please enter your password" : null,
      ));

  Widget _confirmPasswordField() => formatFullRow(
          child: TextFormField(
        controller: _confirmPasswordController,
        decoration: InputDecoration(
            hintText: "Confirm password",
            suffixIcon: TextButton(
                onPressed: _toggleObscureConfirmPasswordText,
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                        _obscureConfirmPasswordText
                            ? Colors.grey
                            : kThemeColor)),
                child: const Icon(Icons.remove_red_eye_rounded))),
        obscureText: _obscureConfirmPasswordText,
        validator: (s) =>
            (s ?? "").isEmpty ? "Please enter your password" : null,
      ));

  Widget _submitButton() => formatFullRow(
      child: ElevatedButton(
          onPressed: _onSubmit,
          child: const Text("Register",
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

  Widget _alreadyAMember() =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("Already a member?",
            style: TextStyle(fontWeight: FontWeight.bold)),
        TextButton(
            onPressed: () => Navigation.login(replace: true),
            child: const Text("Sign in",
                style: TextStyle(fontWeight: FontWeight.bold)))
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            _image(),
            _mailField(),
            _passwordField(),
            _confirmPasswordField(),
            _submitButton(),
            _or(),
            _googleButton(),
            _facebookButton(),
            _alreadyAMember()
          ],
        ),
      ),
    );
  }
}
