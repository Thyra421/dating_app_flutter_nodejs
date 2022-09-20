import 'package:flutter/material.dart';

import 'home.dart';

class Navigation {
  static void home(BuildContext context, {Function? then}) =>
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Home()));
}
