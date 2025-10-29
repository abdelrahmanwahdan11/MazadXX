class I18nAuditService {
  final List<String> _missing = <String>[];

  void reportMissing(String key) {
    if (!_missing.contains(key)) {
      _missing.add(key);
    }
  }

  int get missingCount => _missing.length;

  List<String> get missingKeys => List<String>.unmodifiable(_missing);
}
