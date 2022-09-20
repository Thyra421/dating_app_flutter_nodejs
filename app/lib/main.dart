import 'package:flutter/material.dart';
import 'package:app/global/navigation.dart';

import 'app.dart';

void main() {
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  Navigation.setNavigatorKey(_navigatorKey);
  runApp(App(_navigatorKey));
}
