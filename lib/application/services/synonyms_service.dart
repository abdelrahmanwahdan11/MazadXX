class SynonymsService {
  const SynonymsService();

  static const Map<String, List<String>> _en = {
    'phone': ['mobile', 'smartphone'],
    'car': ['vehicle', 'auto'],
    'watch': ['timepiece'],
    'camera': ['dslr', 'photography'],
    'bid': ['offer', 'propose'],
    'wanted': ['looking', 'seeking'],
  };

  static const Map<String, List<String>> _ar = {
    'هاتف': ['جوال', 'موبايل'],
    'سيارة': ['مركبة'],
    'ساعة': ['وقت'],
    'كاميرا': ['تصوير'],
    'مزاد': ['عرض'],
  };

  List<String> expand(String term, {String locale = 'en_US'}) {
    final normalized = term.toLowerCase().trim();
    if (normalized.isEmpty) {
      return <String>[];
    }
    final map = locale.startsWith('ar') ? _ar : _en;
    final expanded = <String>{normalized};
    for (final entry in map.entries) {
      if (normalized.contains(entry.key)) {
        expanded.addAll(entry.value);
      }
      for (final synonym in entry.value) {
        if (normalized.contains(synonym)) {
          expanded.add(entry.key);
        }
      }
    }
    return expanded.toList(growable: false);
  }
}
