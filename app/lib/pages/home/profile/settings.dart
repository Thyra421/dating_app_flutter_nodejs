import 'package:app/global/api.dart';
import 'package:app/global/navigation.dart';
import 'package:app/utils/future_widget.dart';
import 'package:flutter/material.dart';

import '../../../global/format.dart';
import '../../../theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _appearOnRadar = false;
  bool _trackMyPosition = false;
  bool _notifications = false;
  bool _darkMode = false;
  String _language = "";

  void _onLogout() {
    Api.logout();
    Navigation.login(replace: true);
  }

  Future<void> _setSetting({
    bool? notifications,
    bool? appearOnRadar,
    bool? trackPosition,
    bool? darkMode,
    String? language,
  }) async {
    return await Api.setSettings(
      notifications: notifications,
      appearOnRadar: appearOnRadar,
      trackPosition: trackPosition,
      darkMode: darkMode,
      language: language,
    );
  }

  void _getSettings(Map<String, dynamic> values) => setState(() {
        _appearOnRadar = values['appearOnRadar'] ?? false;
        _trackMyPosition = values['trackPosition'] ?? false;
        _notifications = values['notifications'] ?? false;
        _darkMode = values['darkMode'] ?? false;
        _language = values['language'] ?? "";
      });

  Widget _setting({required Widget child}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
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
                  onChanged: (bool value) {
                    setState(() => _appearOnRadar = value);
                    _setSetting(appearOnRadar: value);
                  }),
            )
          ],
        ),
      );

  Widget _switchTrackMyPosition() => _setting(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: const [
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.my_location)),
              Text("Track my position")
            ]),
            Align(
              alignment: Alignment.centerRight,
              child: Switch(
                  value: _trackMyPosition,
                  onChanged: (bool value) {
                    _setSetting(trackPosition: value);
                    setState(() => _trackMyPosition = value);
                  }),
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
                  onChanged: (bool value) {
                    _setSetting(notifications: value);
                    setState(() => _notifications = value);
                  }),
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
                  onChanged: (bool value) {
                    _setSetting(darkMode: value);
                    setState(() => _darkMode = value);
                  }),
            )
          ],
        ),
      );

  Widget _selectLanguage() => InkWell(
        onTap: () => Navigation.language(then: (value) {
          _setSetting(language: value);
          setState(() => _language = value);
        }),
        child: _setting(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.language)),
                Text.rich(TextSpan(children: [
                  const TextSpan(text: "Language "),
                  TextSpan(
                      text: _language,
                      style: const TextStyle(fontWeight: FontWeight.w300))
                ]))
              ]),
              const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.keyboard_arrow_right))
            ],
          ),
        ),
      );

  Widget _logoutButton() => Center(
        child: TextButton(
            style: ButtonStyle(
                textStyle: MaterialStateProperty.all(const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold))),
            onPressed: _onLogout,
            child: const Text("Sign out")),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureWidget<Map<String, dynamic>>(
              future: () =>
                  Api.getSettings()..then(_getSettings, onError: (_) {}),
              widget: ListView(shrinkWrap: true, children: [
                section("Privacy"),
                _switchAppearOnRadar(),
                _switchTrackMyPosition(),
                section("Notifications"),
                _switchNotifications(),
                section("Display"),
                _selectLanguage(),
                _switchDarkMode(),
              ])),
          _logoutButton(),
        ],
      ));
}
