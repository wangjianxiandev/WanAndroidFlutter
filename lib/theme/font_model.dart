import 'package:flutter/material.dart';
import 'package:wanandroidflutter/application.dart';
import 'package:wanandroidflutter/utils/Config.dart';

class FontModel with ChangeNotifier {
  int _fontIndex;

  get fontIndex => _fontIndex;

  void updateFontIndex(int fontIndex) {
    this._fontIndex = fontIndex;
    notifyListeners();
    Application.sp.putInt(Config.SP_FONT_INDEX, fontIndex);
  }
}
