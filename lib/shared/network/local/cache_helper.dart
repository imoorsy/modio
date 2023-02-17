
import 'package:shared_preferences/shared_preferences.dart';

class cacheHelper
{
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool?> putData({
    required String key,
    required bool value,
  }) async {
    return await sharedPreferences?.setBool(key, value);
  }

  static bool? getData({
    required String key,
  }) {
    return sharedPreferences?.getBool(key);
  }
  static Future<bool?> putSongData({
    required String key,
    required int value,
  }) async {
    return await sharedPreferences?.setInt(key, value);
  }

  static int? getSongData({
    required String key,
  }) {
    return sharedPreferences?.getInt(key);
  }
}