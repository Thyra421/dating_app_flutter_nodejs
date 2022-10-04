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
          const Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold)));

  Widget _googleButton() => ElevatedButton(
      onPressed: _onSubmit,
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
      child: Image.asset("assets/google_logo.png", height: 30));

  Widget _facebookButton() => ElevatedButton(
      onPressed: _onSubmit,
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
      child: Image.asset("assets/facebook_logo.png", height: 20));

  Widget _loginForm() => Form(
      key: _formKey,
      child: Column(children: [
        formatField(_mailField()),
        formatField(_passwordField())
      ]));

  Widget _image() => Image.asset("assets/lust.png");

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
      body: ListView(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _image()),
          _loginForm(),
          formatButtonFullRow(_submitButton()),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                  child: Text("or continue with",
                      style: TextStyle(fontWeight: FontWeight.bold)))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(height: 50, child: _googleButton()))),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(height: 50, child: _facebookButton()))),
              ],
            ),
          ),
          _register()
        ],
      ),
    );
  }
}
