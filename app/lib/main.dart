import 'package:flutter/material.dart';
import 'package:app/global/navigation.dart';
import 'package:flutter/services.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Navigation.setNavigatorKey(navigatorKey);
  runApp(App(navigatorKey));
}
