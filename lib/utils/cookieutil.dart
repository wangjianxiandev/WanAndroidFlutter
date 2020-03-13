import 'dart:async';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class CookieUtil {
  // 获取cookie地址
  static Future<String> getCookiePath() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    return "${tempPath}/cookies";
  }

  //清除所有cookie
  static Future<Null> deleteAllCookies() async {
    await getCookiePath().then((path) {
      PersistCookieJar cookieJar = PersistCookieJar(dir: path);
      cookieJar.deleteAll();
    });
  }
}