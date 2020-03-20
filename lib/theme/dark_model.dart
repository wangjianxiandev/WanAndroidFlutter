import 'package:flutter/material.dart';

class DarkMode with ChangeNotifier {
  bool _isDark = false;

  get isDark => _isDark;

  void setDark(isDark) {
    _isDark = isDark;
    notifyListeners();
  }
}
