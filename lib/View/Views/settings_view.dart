import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/View/Themes/themes.dart';
import 'package:news_app/ViewModel/Providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Widget _buildSettingsTile(
          {Widget? leading,
          Widget? trailing,
          required String? title,
          String? subTitle,
          VoidCallback? onTap}) =>
      ListTile(
        onTap: onTap,
        leading: (leading != null) ? leading : SizedBox(),
        trailing: (trailing != null) ? trailing : SizedBox(),
        title: Text(
          title!,
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: (subTitle != null)
            ? Text(
                subTitle,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontSize: 15,
                    color: Theme.of(context)
                        .textTheme
                        .headline4!
                        .color!
                        .withOpacity(0.4)),
              )
            : const SizedBox(),
      );
  @override
  Widget build(BuildContext context) {
    final ThemeProvider _theme = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: BackButton(
            color: Theme.of(context).iconTheme.color,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Settings',
            style:
                TextStyle(color: Theme.of(context).textTheme.headline4!.color),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSettingsTile(
                    title: 'Language',
                    leading: FaIcon(
                      FontAwesomeIcons.language,
                      color: Theme.of(context).iconTheme.color!,
                      size: 18,
                    )),
                _buildSettingsTile(
                    title: 'Font',
                    leading: FaIcon(
                      FontAwesomeIcons.font,
                      color: Theme.of(context).iconTheme.color!,
                      size: 18,
                    )),
                _buildSettingsTile(
                  onTap: () {
                    switch (AppTheme.themeModeType) {
                      case 'System':
                        _theme.changeTheme(theme: 'Light');
                        break;
                      case 'Light':
                        _theme.changeTheme(theme: 'Dark');
                        break;
                      case 'Dark':
                        _theme.changeTheme(theme: 'System');
                        break;
                    }
                  },
                  title: 'Theme',
                  subTitle: AppTheme.themeModeType,
                  leading: Icon(
                    MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: Theme.of(context).iconTheme.color!,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
