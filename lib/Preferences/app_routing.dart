import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppRoute {
  static void navigateTo(BuildContext context, Widget screen) =>
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => screen));
  static void popAndNavigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context);
    navigateTo(context, screen);
  }
}
