import 'package:flutter/material.dart';

class FontModel with ChangeNotifier {
  int _fontIndex;

  get fontIndex => _fontIndex;

  void updateFontIndex(int fontIndex) {
    this._fontIndex = fontIndex;
    notifyListeners();
  }
}
