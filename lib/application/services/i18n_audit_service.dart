class I18nAuditService {
  int missingKeys = 0;

  void reportMissing(String key) {
    missingKeys++;
  }
}
