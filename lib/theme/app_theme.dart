import 'package:flutter/material.dart';

class AppTheme with ChangeNotifier {
  Color _themeColor;

  get themeColor => _themeColor;

  void updateThemeColor(Color color) {
    this._themeColor = color;
    notifyListeners();
  }
}
