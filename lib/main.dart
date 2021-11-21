import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/View/Themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ViewModel/Providers/theme_provider.dart';
import 'View/Views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var systemOverLay = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemOverLay);
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
  final _pref = await SharedPreferences.getInstance();
  AppTheme.themeModeType = _pref.getString('Theme') ?? 'System';
  AppTheme.setThemeMode(themeMode: AppTheme.themeModeType);
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: AppTheme.getThemeMode(),
      home: const HomeScreen(title: 'News'),
    );
  }
}
