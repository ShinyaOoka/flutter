
import 'package:shared_preferences/shared_preferences.dart';


class SharedPrefManager {
  static SharedPrefManager? _instance;

  static Future<SharedPrefManager?> get instance async {
    return await getInstance();
  }

  static SharedPreferences? spf;

  SharedPrefManager();

  SharedPrefManager._();

  Future _init() async {
    spf = await SharedPreferences.getInstance();
  }

  static Future<SharedPrefManager?> getInstance() async {
    if (_instance == null) {
      _instance = new SharedPrefManager._();
      await _instance!._init();
    }
    return _instance;
  }

  static bool beforCheck() {
    if (spf == null) {
      return true;
    }
    return false;
  }

  // 判断是否存在数据
  bool hasKey(String key) {
    Set<String>? keys = getKeys();
    return keys!.contains(key);
  }

  Set<String>? getKeys() {
    if (beforCheck()) return null;
    return spf!.getKeys();
  }

  get(String key) {
    if (beforCheck()) return null;
    return spf!.get(key);
  }

  getString(String key) {
    if (beforCheck()) return null;
    return spf!.getString(key);
  }

  Future<bool>? putString(String key, String value) {
    if (beforCheck()) return null;
    return spf!.setString(key, value);
  }

  bool? getBool(String key) {
    if (beforCheck()) return null;
    return spf!.getBool(key);
  }

  Future<bool>? putBool(String key, bool value) {
    if (beforCheck()) return null;
    return spf!.setBool(key, value);
  }

  int? getInt(String key) {
    if (beforCheck()) return null;
    return spf!.getInt(key);
  }

  Future<bool>? putInt(String key, int value) {
    if (beforCheck()) return null;
    return spf!.setInt(key, value);
  }

  double? getDouble(String key) {
    if (beforCheck()) return null;
    return spf!.getDouble(key);
  }

  Future<bool>? putDouble(String key, double value) {
    if (beforCheck()) return null;
    return spf!.setDouble(key, value);
  }

  List<String>? getStringList(String key) {
    return spf!.getStringList(key);
  }

  Future<bool>? putStringList(String key, List<String> value) {
    if (beforCheck()) return null;
    return spf!.setStringList(key, value);
  }

  dynamic getDynamic(String key) {
    if (beforCheck()) return null;
    return spf!.get(key);
  }

  Future<bool>? remove(String key) {
    if (beforCheck()) return null;
    return spf!.remove(key);
  }

  Future<bool>? clear() {
    if (beforCheck()) return null;
    return spf!.clear();
  }
}

class UserSharePref extends SharedPrefManager {
  static const APPLE_ID = 'APPLE_ID';

  Future<void>? saveAppleId(String? value) {
    if (SharedPrefManager.beforCheck()) return null;
    return SharedPrefManager.spf!.setString(APPLE_ID, value ?? '');
  }

  String getAppleId() {
    if (SharedPrefManager.beforCheck()) return '';
    return SharedPrefManager.spf!.getString(APPLE_ID) ?? '';
  }

}
