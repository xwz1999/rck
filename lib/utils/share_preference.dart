/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/26  2:15 PM 
 * remark    : 
 * ====================================================
 */

import 'package:shared_preferences/shared_preferences.dart';

class SharePreferenceUtils {
  static setString(key, String value) async {
    SharedPreferences preferences = await _getPreference();
    return await preferences.setString(key, value);
  }

  static Future<String?> getString(key) async {
    SharedPreferences preferences = await _getPreference();
    return preferences.getString(key);
  }

  static Future<bool> remove(key) async {
    SharedPreferences preferences = await _getPreference();
    return preferences.remove(key);
  }

  static setInt(key, int value) async {
    SharedPreferences preferences = await _getPreference();
    return preferences.setInt(key, value);
  }

  static Future<int?> getInt(key) async {
    SharedPreferences preferences = await _getPreference();
    return preferences.getInt(key);
  }

  static setBool(key, value) async {
    SharedPreferences preferences = await _getPreference();
    return preferences.setBool(key, value);
  }

  static Future<bool?> getBool(key) async {
    SharedPreferences preferences = await _getPreference();
    return preferences.getBool(key);
  }

  static Future<SharedPreferences> _getPreference() async {
    return await SharedPreferences.getInstance();
  }
}
