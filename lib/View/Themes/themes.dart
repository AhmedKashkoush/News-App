import 'package:flutter/material.dart';

class AppTheme {
  static String themeModeType = 'System';
  static ThemeMode? themeMode = ThemeMode.system;
  static setThemeMode({String? themeMode}) {
    themeModeType = themeMode!;
    AppTheme.themeMode = themeMode.toLowerCase() == 'light'
        ? ThemeMode.light
        : themeMode.toLowerCase() == 'dark'
            ? ThemeMode.dark
            : ThemeMode.system;
    return AppTheme.themeMode;
  }

  static ThemeMode getThemeMode() {
    switch (AppTheme.themeModeType) {
      case 'Light':
        return ThemeMode.light;
      case 'Dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static final ThemeData? lightTheme = ThemeData(
    primaryColor: Colors.red,
    primarySwatch: Colors.red,
    scaffoldBackgroundColor: Colors.white,
    //appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.black87)),
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black87),
    textTheme:
        TextTheme(headline4: TextStyle(color: Colors.black87, fontSize: 16)),
    //splashColor: Colors.transparent,
    accentColor: Colors.blueAccent,
    highlightColor: Colors.transparent,
    splashFactory: InkRipple.splashFactory,
    //pageTransitionsTheme: _pageTransition,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final ThemeData? darkTheme = ThemeData(
    primaryColor: Colors.grey[850],
    primarySwatch: Colors.red,
    scaffoldBackgroundColor: Colors.grey[900],
    //appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
    backgroundColor: Colors.grey[850],
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      headline4: TextStyle(color: Colors.white, fontSize: 16),
    ),
    //splashColor: Colors.transparent,
    accentColor: Colors.blueAccent,
    highlightColor: Colors.transparent,
    splashFactory: InkRipple.splashFactory,
    //pageTransitionsTheme: _pageTransition,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  //static ThemeMode getThemeMode({String? themeMode})

  // static PageTransitionsTheme _pageTransition = PageTransitionsTheme(builders: {
  //   TargetPlatform.android: CupertinoPageTransitionsBuilder(),
  //   TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  //   TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
  //   TargetPlatform.windows: OpenUpwardsPageTransitionsBuilder(),
  //   TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
  //   TargetPlatform.fuchsia: OpenUpwardsPageTransitionsBuilder(),
  // });
}
