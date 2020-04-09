import 'package:flutter/material.dart';

class ThemeModel with ChangeNotifier {
  Color _themeColor;

  get themeColor => _themeColor;

  void updateThemeColor(Color color) {
    this._themeColor = color;
    notifyListeners();
  }
}
