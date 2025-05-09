import 'package:flutter/material.dart';

class AppControler extends ChangeNotifier {
  static AppControler instance = AppControler();

  bool isdartTheme = false;
  changeTheme() {
    isdartTheme = !isdartTheme;
    notifyListeners();
  }
}
