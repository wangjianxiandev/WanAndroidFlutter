import 'package:flutter/material.dart';
import 'package:wanandroidflutter/application.dart';
import 'package:wanandroidflutter/utils/Config.dart';

class DarkMode with ChangeNotifier {
  bool _isDark = false;

  get isDark => _isDark;

  void updateDarkMode(isDark) {
    _isDark = isDark;
    notifyListeners();
    Application.sp.putBool(Config.SP_DARK_MODEL, isDark);
  }
}
