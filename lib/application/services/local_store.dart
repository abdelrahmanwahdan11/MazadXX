class LocalStore {
  final Map<String, Object> _storage = <String, Object>{};

  Future<void> writeJson(String key, Object value) async {
    _storage[key] = value;
  }

  Map<String, dynamic>? readJson(String key) {
    final value = _storage[key];
    if (value is Map<String, dynamic>) {
      return value;
    }
    return null;
  }

  Future<void> writeList(String key, List<Object> value) async {
    _storage[key] = value;
  }

  List<dynamic> readList(String key) {
    final value = _storage[key];
    if (value is List<dynamic>) {
      return value;
    }
    return <dynamic>[];
  }

  Future<void> writeBool(String key, bool value) async {
    _storage[key] = value;
  }

  bool readBool(String key, {bool fallback = false}) {
    final value = _storage[key];
    if (value is bool) {
      return value;
    }
    return fallback;
  }
}
