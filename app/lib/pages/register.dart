import 'package:app/global/navigation.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global/format.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      http.post(Uri.http('localhost:8080/register'), body: {
        "username": _usernameController.text,
        "password": _passwordController.text
      });
      Navigation.home();
    }
  }

  void _toggleObscurePassword() =>
      setState(() => _obscurePassword = !_obscurePassword);
  void _toggleObscurePasswordConfirm() =>
      setState(() => _obscurePasswordConfirm = !_obscurePasswordConfirm);

  Widget _mailField() => TextFormField(
      controller: _mailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(hintText: "Mail"),
      validator: (s) => (s ?? "").isEmpty ? "Please enter your mail" : null);

  Widget _usernameField() => TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(hintText: "Username"),
      validator: (s) =>
          (s ?? "").isEmpty ? "Please enter your username" : null);

  Widget _passwordField() => TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
          hintText: "Password",
          suffixIcon: TextButton(
              onPressed: _toggleObscurePassword,
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                      _obscurePassword ? Colors.grey : kThemeColor)),
              child: const Icon(Icons.remove_red_eye_rounded))),
      obscureText: _obscurePassword,
      validator: (s) =>
          (s ?? "").isEmpty ? "Please enter your password" : null);

  Widget _passwordConfirmField() => TextFormField(
      controller: _passwordConfirmController,
      decoration: InputDecoration(
          hintText: "Confirm password",
          suffixIcon: TextButton(
              onPressed: _toggleObscurePasswordConfirm,
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                      _obscurePasswordConfirm ? Colors.grey : kThemeColor)),
              child: const Icon(Icons.remove_red_eye_rounded))),
      obscureText: _obscurePasswordConfirm,
      validator: (s) => null
      // (s ?? "").isEmpty
      //     ? "Please confirm your password"
      //     : s == (_passwordController.text)
      //         ? "Passwords don't match"
      //         : null
      );

  Widget _submitButton() => ElevatedButton(
      onPressed: _onSubmit,
      child: const Text("REGISTER",
          style: TextStyle(fontWeight: FontWeight.bold)));

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

  Widget _registerForm() => Form(
      key: _formKey,
      child: Column(children: [
        formatField(_usernameField()),
        formatField(_mailField()),
        formatField(_passwordField()),
        formatField(_passwordConfirmField())
      ]));

  Widget _image() => Image.asset("lust.png", height: 400);

  Widget _login() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already a member?",
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
              onPressed: () => Navigation.login(replace: true),
              child: const Text("Login",
                  style: TextStyle(fontWeight: FontWeight.bold)))
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              _image(),
              _registerForm(),
              formatButtonFullRow(_submitButton()),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text("or",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              // formatButton(_googleButton()),
              // formatButton(_facebookButton()),
              _login()
            ],
          ),
        ),
      ),
    );
  }
}
