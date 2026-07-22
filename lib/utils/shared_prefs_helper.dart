import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _keyLt = 'lt';
  static const String _keyLn = 'ln';
  static const String _keyCid = 'cid';
  static const String _keyUserId = 'userId';
  static const String _keyDeviceId = 'deviceId';

  // ── LT ──────────────────────────────────────────────────────────────────
  static Future<void> setLt(String lt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLt, lt);
  }

  static Future<String?> getLt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLt);
  }

  // ── LN ──────────────────────────────────────────────────────────────────
  static Future<void> setLn(String ln) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLn, ln);
  }

  static Future<String?> getLn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLn);
  }

  // ── CID ─────────────────────────────────────────────────────────────────
  static Future<void> setCid(String cid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCid, cid);
  }

  static Future<String?> getCid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCid);
  }

  // ── USER ID ─────────────────────────────────────────────────────────────
  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  // ── DEVICE ID ───────────────────────────────────────────────────────────
  static Future<void> setDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDeviceId, deviceId);
  }

  static Future<String?> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDeviceId);
  }

  // ── CLEAR ALL ───────────────────────────────────────────────────────────
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLt);
    await prefs.remove(_keyLn);
    await prefs.remove(_keyCid);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyDeviceId);
  }
}
