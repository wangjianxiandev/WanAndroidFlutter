import 'package:flutter/services.dart';

class ClipboardUtil {
  static saveData2Clipboard(String text) {
    ClipboardData data = new ClipboardData(text: text);
    Clipboard.setData(data);
  }

  static Future<String> getClipboardContents() async {
    var clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    return Future.value(clipboardData.text);
  }
}
