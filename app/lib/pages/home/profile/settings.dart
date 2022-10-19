import 'package:app/global/api.dart';
import 'package:app/global/navigation.dart';
import 'package:app/utils/future_widget.dart';
import 'package:flutter/material.dart';

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

  void _onLogout() {
    Api.logout();
    Navigation.login(replace: true);
  }

  Future<void> _setSetting(String name, dynamic value) async {
    return await Api.setSettings(name, value);
  }

  void _getSettings(Map<String, dynamic> values) => setState(() {
        _appearOnRadar = values['appear_on_radar'] ?? false;
        _trackMyPosition = values['track_position'] ?? false;
        _notifications = values['notifications'] ?? false;
        _darkMode = values['dark_mode'] ?? false;
      });

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
                  onChanged: (bool value) {
                    setState(() => _appearOnRadar = value);
                    _setSetting('appear_on_radar', value);
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
                    _setSetting('track_position', value);
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
                    _setSetting('notifications', value);
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
                    _setSetting('dark_mode', value);
                    setState(() => _darkMode = value);
                  }),
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
      body: FutureWidget<Map<String, dynamic>>(
          future: () => Api.getSettings()..then(_getSettings, onError: (_) {}),
          widget: ListView(children: [
            _section("Privacy"),
            _switchAppearOnRadar(),
            _switchTrackMyPosition(),
            _section("Notifications"),
            _switchNotifications(),
            _section("Display"),
            _language(),
            _switchDarkMode(),
            _logoutButton(),
          ])));
}
