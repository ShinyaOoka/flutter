import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../model/cart_product_data.dart';
import '../../model/login_config.dart';
import '../../model/login_data.dart';
import '../../model/session_info.dart';
import '../network/response/shops_response.dart';

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
  static const USER = 'USER';
  static const SHOP = 'SHOP';
  static const LOAD_START_API = 'LOAD_START_API';
  static const APP_TOKEN = 'APP_TOKEN';
  static const CSRT_TOKEN = 'CSRT_TOKEN';
  static const FIREBASE_DEVICE_TOKEN = 'FIREBASE_DEVICE_TOKEN';
  static const LOGIN_TYPE = 'LOGIN_TYPE';
  static const TWITTER_ID = 'TWITTER_ID';
  static const APPLE_ID = 'APPLE_ID';
  static const APPLE_USER_NAME = 'APPLE_USER_NAME';
  static const LOGIN_CONFIG = 'LOGIN_CONFIG';
  static const LOGIN_DATA_LIST = 'LOGIN_DATA_LIST';
  static const CART_PRODUCT = 'CART_PRODUCT';

  Future<void>? saveFirebaseToken(String? value) {
    if (SharedPrefManager.beforCheck()) return null;
    return SharedPrefManager.spf!.setString(FIREBASE_DEVICE_TOKEN, value ?? '');
  }

  String getFirebaseToken() {
    if (SharedPrefManager.beforCheck()) return '';
    return SharedPrefManager.spf!.getString(FIREBASE_DEVICE_TOKEN) ?? '';
  }

  Future<void>? saveLoginType(int value) {
    if (SharedPrefManager.beforCheck()) return null;
    return SharedPrefManager.spf!.setInt(LOGIN_TYPE, value);
  }

  int getLoginType() {
    if (SharedPrefManager.beforCheck()) return 1;
    return SharedPrefManager.spf!.getInt(LOGIN_TYPE) ?? 1;
  }

  Future<void>? saveTwitterId(String? value) {
    if (SharedPrefManager.beforCheck()) return null;
    return SharedPrefManager.spf!.setString(TWITTER_ID, value ?? '');
  }

  String getTwitterId() {
    if (SharedPrefManager.beforCheck()) return '';
    return SharedPrefManager.spf!.getString(TWITTER_ID) ?? '';
  }

  Future<void>? saveAppleId(String? value) {
    if (SharedPrefManager.beforCheck()) return null;
    return SharedPrefManager.spf!.setString(APPLE_ID, value ?? '');
  }

  String getAppleId() {
    if (SharedPrefManager.beforCheck()) return '';
    return SharedPrefManager.spf!.getString(APPLE_ID) ?? '';
  }

  Future<void>? saveAppleUserName(String? value) {
    if (SharedPrefManager.beforCheck()) return null;
    return SharedPrefManager.spf!.setString(APPLE_USER_NAME, value ?? '');
  }

  String getAppleUserName() {
    if (SharedPrefManager.beforCheck()) return '';
    return SharedPrefManager.spf!.getString(APPLE_USER_NAME) ?? '';
  }

  Future<void>? saveAppToken(String? value) {
    if (SharedPrefManager.beforCheck()) return null;
    return SharedPrefManager.spf!.setString(APP_TOKEN, value ?? '');
  }

  String getAppToken() {
    if (SharedPrefManager.beforCheck()) return '';
    return SharedPrefManager.spf!.getString(APP_TOKEN) ?? '';
  }

  Future<void>? saveCsrtToken(String? value) {
    if (SharedPrefManager.beforCheck()) return null;
    return SharedPrefManager.spf!.setString(CSRT_TOKEN, value ?? '');
  }

  String getCsrtToken() {
    if (SharedPrefManager.beforCheck()) return '';
    return SharedPrefManager.spf!.getString(CSRT_TOKEN) ?? '';
  }

  Future<void>? saveUser(SessionInfo? user) {
    if (SharedPrefManager.beforCheck()) return null;
    return SharedPrefManager.spf!
        .setString(USER, user != null ? json.encode(user.toJson()) : '');
  }

  Future<void>? clearUser() {
    saveUser(null);
  }

  SessionInfo? getUser() {
    if (SharedPrefManager.beforCheck()) return null;
    String jsonData = SharedPrefManager.spf!.getString(USER) ?? '';
    if (jsonData.isEmpty) return null;
    dynamic data = json.decode(jsonData);
    return SessionInfo.fromJson(data);
  }

  Future<void>? saveLoginDataList(LoginData? loginDataList) {
    if (SharedPrefManager.beforCheck()) return null;
    return SharedPrefManager.spf!.setString(LOGIN_DATA_LIST,
        loginDataList != null ? json.encode(loginDataList.toJson()) : '');
  }

  LoginData? getLoginDataList() {
    if (SharedPrefManager.beforCheck()) return null;
    String jsonData = SharedPrefManager.spf!.getString(LOGIN_DATA_LIST) ?? '';
    if (jsonData.isEmpty) return null;
    dynamic data = json.decode(jsonData);
    return LoginData.fromJson(data);
  }


  Future<void>? saveLoginConfig(LoginConfig? loginConfig) {
    if (SharedPrefManager.beforCheck()) return null;
    return SharedPrefManager.spf!.setString(LOGIN_CONFIG,
        loginConfig != null ? json.encode(loginConfig.toJson()) : '');
  }

  LoginConfig? getLoginConfig() {
    if (SharedPrefManager.beforCheck()) return null;
    String jsonData = SharedPrefManager.spf!.getString(LOGIN_CONFIG) ?? '';
    if (jsonData.isEmpty) return null;
    dynamic data = json.decode(jsonData);
    return LoginConfig.fromJson(data);
  }

  bool hasLoginConfig() {
    if (SharedPrefManager.beforCheck()) return false;
    return getLoginDataList() != null &&
        getLoginDataList()?.data.isNotEmpty == true;
  }


  Future<void>? saveShop(Shop? shop) {
    if (SharedPrefManager.beforCheck()) return null;
    return SharedPrefManager.spf!
        .setString(SHOP, shop != null ? json.encode(shop.toJson()) : '');
  }

  Shop? getShop() {
    if (SharedPrefManager.beforCheck()) return null;
    String jsonData = SharedPrefManager.spf!.getString(SHOP) ?? '';
    if (jsonData.isEmpty) return null;
    dynamic data = json.decode(jsonData);
    return Shop.fromJson(data);
  }


  bool isLogin() {
    if (SharedPrefManager.beforCheck()) return false;
    return getUser() != null && getUser()!.uid != null;
  }


  Future<void>? saveCartProductData(CartProductData? cartProductData) {
    if (SharedPrefManager.beforCheck()) return null;
    return SharedPrefManager.spf!.setString(CART_PRODUCT,
        cartProductData != null ? json.encode(cartProductData.toJson()) : '');
  }

  CartProductData? getCartProductData() {
    if (SharedPrefManager.beforCheck()) return null;
    String jsonData = SharedPrefManager.spf!.getString(CART_PRODUCT) ?? '';
    if (jsonData.isEmpty) return null;
    dynamic data = json.decode(jsonData);
    return CartProductData.fromJson(data);
  }
}
