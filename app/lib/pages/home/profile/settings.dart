import 'package:app/data/error_data.dart';
import 'package:app/data/settings_data.dart';
import 'package:app/global/api.dart';
import 'package:app/global/messenger.dart';
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
  SettingsData _settingsData = SettingsData();

  void _onLogout() {
    Api.logout();
    Navigation.login(replace: true);
  }

  void _setSetting(SettingsData settingsData) async {
    SettingsData backup = SettingsData()..setFrom(_settingsData);

    setState(() => _settingsData.setFrom(settingsData));
    try {
      await Api.setSettings(settingsData);
    } catch (error) {
      setState(() => _settingsData.setFrom(backup));
      Messenger.showSnackBar("Failed changing setting");
    }
  }

  void _getSettings(SettingsData settingsData) =>
      setState(() => _settingsData = settingsData);

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
                  value: _settingsData.appearOnRadar ?? false,
                  onChanged: _settingsData.appearOnRadar == null
                      ? null
                      : (bool value) =>
                          _setSetting(SettingsData(appearOnRadar: value))),
            )
          ],
        ),
      );

  Widget _switchTrackPosition() => _setting(
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
                  value: _settingsData.trackPosition ?? false,
                  onChanged: _settingsData.trackPosition == null
                      ? null
                      : (bool value) =>
                          _setSetting(SettingsData(trackPosition: value))),
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
                  value: _settingsData.notifications ?? false,
                  onChanged: _settingsData.notifications == null
                      ? null
                      : (bool value) =>
                          _setSetting(SettingsData(notifications: value))),
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
                  value: _settingsData.darkMode ?? false,
                  onChanged: _settingsData.darkMode == null
                      ? null
                      : (bool value) =>
                          _setSetting(SettingsData(darkMode: value))),
            )
          ],
        ),
      );

  Widget _selectLanguage() => InkWell(
        onTap: () => _settingsData.language == null
            ? null
            : Navigation.language(
                then: (value) => _setSetting(SettingsData(language: value))),
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
                      text: _settingsData.language ?? "",
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
          FutureWidget(
              future: () =>
                  Api.getSettings()..then(_getSettings, onError: (_) {}),
              widget: ListView(shrinkWrap: true, children: [
                section("Privacy"),
                _switchAppearOnRadar(),
                _switchTrackPosition(),
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
