import 'package:shared_preferences/shared_preferences.dart';

class localStorage {
  static late SharedPreferences _instance ;

  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }
  static Future<bool> setString(String key, String value) async {
    return await _instance.setString(key, value);
  }
  static String? getString(String key) {
    return _instance.getString(key);
  }
  static Future<bool> setBool(String key, bool value) async {
    return await _instance.setBool(key, value);
  }
  static bool? getBool(String key) {
    return _instance.getBool(key);
  }
  static Future<bool> setInt(String key, int value) async {
    return await _instance.setInt(key, value);
  }
  static int? getInt(String key) {
    return _instance.getInt(key);
  }
  static Future<bool> setDouble(String key, double value) async {
    return await _instance.setDouble(key, value);
  }
  static double? getDouble(String key) {
    return _instance.getDouble(key);
  }
  static Future<bool> setStringList(String key, List<String> value) async {
    return await _instance.setStringList(key, value);
  }
  static List<String>? getStringList(String key) {
    return _instance.getStringList(key);
  }
  static Future<bool> remove(String key) async {
    return await _instance.remove(key);
  }
  static Future<bool> clear() async {
    return await _instance.clear();
  }
  static Future<bool> containsKey(String key) async {
    return _instance.containsKey(key);
  }
  


  

 
}