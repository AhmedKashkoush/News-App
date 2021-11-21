import 'package:flutter/cupertino.dart';
import 'package:news_app/View/Themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  SharedPreferences? _pref;
  Future _initPref() async => _pref = await SharedPreferences.getInstance();

  void changeTheme({required String? theme}) async {
    await _initPref();
    AppTheme.setThemeMode(themeMode: theme);
    _pref!.setString('Theme', theme!);
    notifyListeners();
  }
}
