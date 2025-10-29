import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  LocalStore(this._prefs);

  final SharedPreferences? _prefs;
  final Map<String, Object?> _memory = <String, Object?>{};

  static Future<LocalStore> create() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return LocalStore(prefs);
    } catch (_) {
      return LocalStore(null);
    }
  }

  Future<void> writeJson(String key, Object value) async {
    _memory[key] = value;
    final encoded = jsonEncode(value);
    await _prefs?.setString(key, encoded);
  }

  Map<String, dynamic>? readJson(String key) {
    final cached = _memory[key];
    if (cached is Map<String, dynamic>) {
      return cached;
    }
    final raw = _prefs?.getString(key);
    if (raw == null) {
      return null;
    }
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      _memory[key] = decoded;
      return decoded;
    }
    return null;
  }

  Future<void> writeList(String key, List<Object> value) async {
    _memory[key] = value;
    final encoded = jsonEncode(value);
    await _prefs?.setString(key, encoded);
  }

  List<dynamic> readList(String key) {
    final cached = _memory[key];
    if (cached is List<dynamic>) {
      return cached;
    }
    final raw = _prefs?.getString(key);
    if (raw == null) {
      return <dynamic>[];
    }
    final decoded = jsonDecode(raw);
    if (decoded is List<dynamic>) {
      _memory[key] = decoded;
      return decoded;
    }
    return <dynamic>[];
  }

  Future<void> writeBool(String key, bool value) async {
    _memory[key] = value;
    await _prefs?.setBool(key, value);
  }

  bool readBool(String key, {bool fallback = false}) {
    final cached = _memory[key];
    if (cached is bool) {
      return cached;
    }
    final value = _prefs?.getBool(key);
    if (value == null) {
      return fallback;
    }
    _memory[key] = value;
    return value;
  }
}
