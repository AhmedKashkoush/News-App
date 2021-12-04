import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

class ConnectionProvider extends ChangeNotifier {
  ConnectivityResult? connectionState;
  Future<void> checkConectivity() async {
    connectionState = await Connectivity().checkConnectivity();
    notifyListeners();
  }
}
