import 'package:app/global/navigation.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _appearOnRadar = true;
  bool _notifications = false;
  bool _darkMode = true;

  void _onLogout() {
    Navigation.login(replace: true);
    return;
  }

  void _toggleSetting(bool setting) => setState(() => setting = !setting);

  Widget _section(String name) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)));

  Widget _setting({required Widget child}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(height: 70, child: child));

  Widget _switchAppearOnRadar() => _setting(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: const [
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.radar)),
              Text("Appear on radar")
            ]),
            Align(
              alignment: Alignment.centerRight,
              child: Switch(
                  value: _appearOnRadar,
                  onChanged: (bool value) =>
                      setState(() => _appearOnRadar = value)),
            )
          ],
        ),
      );

  Widget _switchNotifications() => _setting(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: const [
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.notifications)),
              Text("Notifications")
            ]),
            Align(
              alignment: Alignment.centerRight,
              child: Switch(
                  value: _notifications,
                  onChanged: (bool value) =>
                      setState(() => _notifications = value)),
            )
          ],
        ),
      );

  Widget _switchDarkMode() => _setting(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: const [
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.dark_mode)),
              Text("Dark mode")
            ]),
            Align(
              alignment: Alignment.centerRight,
              child: Switch(
                  value: _darkMode,
                  onChanged: (bool value) => setState(() => _darkMode = value)),
            )
          ],
        ),
      );

  Widget _language() => InkWell(
        onTap: Navigation.language,
        child: _setting(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: const [
                Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.language)),
                Text.rich(TextSpan(children: [
                  TextSpan(text: "Language "),
                  TextSpan(
                      text: "English US",
                      style: TextStyle(fontWeight: FontWeight.w300))
                ]))
              ]),
              const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.keyboard_arrow_right))
            ],
          ),
        ),
      );

  Widget _logoutButton() => TextButton(
      style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
              const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
      onPressed: _onLogout,
      child: const Text("Sign out"));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(automaticallyImplyLeading: true),
        body: ListView(children: [
          _section("Privacy"),
          _switchAppearOnRadar(),
          _section("Notifications"),
          _switchNotifications(),
          _section("Display"),
          _language(),
          _switchDarkMode(),
          _logoutButton(),
        ]),
      );
}
