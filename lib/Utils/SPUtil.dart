import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class SPUtil {
  SharedPreferences _prefs;

  static SPUtil _instance;

  static Future<SPUtil> getInstance() async {
    if (_instance == null) {
      await synchronized(_lock, () async {
        if (_instance == null) {
          _instance = new SPUtil._();
          await _instance._init();
        }
      });
    }
    return _instance;
  }

  SPUtil._();

  static Object _lock = new Object();

  _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  setString(String key, String value) {
    _prefs.setString(key, value);
  }

  setBool(String key, bool value) {
    _prefs.setBool(key, value);
  }

  setInt(String key, int value) {
    _prefs.setInt(key, value);
  }

  setDouble(String key, double value) {
    _prefs.setDouble(key, value);
  }

  setStringList(String key, List<String> value) {
    _prefs.setStringList(key, value);
  }

  String getString(String key) {
    return _prefs.getString(key);
  }

  bool getBool(String key) {
    return _prefs.getBool(key);
  }

  int getInt(String key) {
    return _prefs.getInt(key);
  }

  double getDouble(String key) {
    return _prefs.getDouble(key);
  }

  List<String> getStringList(String key) {
    return _prefs.getStringList(key);
  }
}
