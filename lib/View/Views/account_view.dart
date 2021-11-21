import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
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
            'Account',
            style:
                TextStyle(color: Theme.of(context).textTheme.headline4!.color),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[700]!.withOpacity(0.4),
                  radius: 45,
                  child: FaIcon(
                    FontAwesomeIcons.userAlt,
                    size: 40,
                    color: Theme.of(context).scaffoldBackgroundColor,
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
