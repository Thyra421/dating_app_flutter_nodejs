import 'package:lust/global/messenger.dart';
import 'package:flutter/material.dart';
import 'package:lust/global/navigation.dart';
import 'package:flutter/services.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  Navigation.setNavigatorKey(navigatorKey);
  Messenger.setMessengerrKey(messengerKey);
  runApp(App(navigatorKey, messengerKey));
}
