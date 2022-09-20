import 'package:app/global/navigation.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';

import '../global/format.dart';

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

  void _onSubmit() {
    if (_formKey.currentState!.validate()) Navigation.home();
  }

  void _toggleObscureText() => setState(() => _obscureText = !_obscureText);

  Widget _mailField() => TextFormField(
      controller: _mailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(hintText: "Mail"),
      validator: (s) => (s ?? "").isEmpty ? "Please enter your mail" : null);

  Widget _passwordField() => TextFormField(
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
          (s ?? "").isEmpty ? "Please enter your password" : null);

  Widget _submitButton() => ElevatedButton(
      onPressed: _onSubmit,
      child:
          const Text("LOGIN", style: TextStyle(fontWeight: FontWeight.bold)));

  Widget _googleButton() => ElevatedButton(
      onPressed: _onSubmit,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(Colors.red)),
      child:
          const Text("Google", style: TextStyle(fontWeight: FontWeight.bold)));

  Widget _facebookButton() => ElevatedButton(
      onPressed: _onSubmit,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(Colors.blue)),
      child: const Text("Facebook",
          style: TextStyle(fontWeight: FontWeight.bold)));

  Widget _loginForm() => Form(
      key: _formKey,
      child: Column(children: [
        formatField(_mailField()),
        formatField(_passwordField())
      ]));

  Widget _image() => Image.asset("lust.png", height: 400);

  Widget _register() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Not a member?",
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
              onPressed: () => Navigation.register(replace: true),
              child: const Text("Register",
                  style: TextStyle(fontWeight: FontWeight.bold)))
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _image(),
          _loginForm(),
          formatButton(_submitButton()),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text("or", style: TextStyle(fontWeight: FontWeight.bold))),
          formatButton(_googleButton()),
          formatButton(_facebookButton()),
          _register()
        ],
      ),
    );
  }
}
