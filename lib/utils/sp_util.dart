import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  static SpUtil _instance;

  static Future<SpUtil> get instance async {
    return await getInstance();
  }

  static SharedPreferences _sp;

  SpUtil._internal();

  Future _init() async {
    _sp = await SharedPreferences.getInstance();
  }

  static Future<SpUtil> getInstance() async {
    if (_instance == null) {
      _instance = SpUtil._internal();
    }
    if (_sp == null) {
      await _instance._init();
    }
    return _instance;
  }

  static bool _beforeCheck() {
    if (_sp == null) {
      return true;
    }
    return false;
  }

  bool hasKey(String key) {
    Set keys = getKeys();
    return keys.contains(key);
  }

  Set<String> getKeys() {
    if (_beforeCheck()) {
      return null;
    }
    return _sp.getKeys();
  }

  get(String key) {
    return _sp.get(key);
  }

  getString(String key) {
    if (_beforeCheck()) {
      return null;
    }
    return _sp.getString(key);
  }

  Future<bool> putString(String key, String value) async {
    if (_beforeCheck()) {
      return null;
    }
    return _sp.setString(key, value);
  }

  getInt(String key) {
    if (_beforeCheck()) {
      return null;
    }
    return _sp.getInt(key);
  }

  Future<bool> putInt(String key, int value) async {
    if (_beforeCheck()) {
      return null;
    }
    return _sp.setInt(key, value);
  }

  bool getBool(String key) {
    if (_beforeCheck()) {
      return null;
    }
    return _sp.getBool(key);
  }

  Future<bool> putBool(String key, bool value) {
    if (_beforeCheck()) {
      return null;
    }
    return _sp.setBool(key, value);
  }

  double getDouble(String key) {
    if (_beforeCheck()) {
      return null;
    }
    return _sp.getDouble(key);
  }

  Future<bool> putDouble(String key, double value) {
    if (_beforeCheck()) {
      return null;
    }
    return _sp.setDouble(key, value);
  }

  List<String> getStringList(String key) {
    return _sp.getStringList(key);
  }

  Future<bool> putStringList(String key, List<String> value) {
    if (_beforeCheck()) {
      return null;
    }
    return _sp.setStringList(key, value);
  }

  dynamic getDynamic(String key) {
    if (_beforeCheck()) {
      return null;
    }
    return _sp.get(key);
  }

  Future<bool> remove(String key) {
    if (_beforeCheck()) {
      return null;
    }
    return _sp.remove(key);
  }

  Future<bool> clear() {
    if (_beforeCheck()) {
      return null;
    }
    return _sp.clear();
  }
}
