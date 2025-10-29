class SavedSearch {
  const SavedSearch({
    required this.id,
    required this.scope,
    required this.query,
    required this.filters,
    required this.date,
  });

  final String id;
  final String scope;
  final String query;
  final Map<String, dynamic> filters;
  final DateTime date;
}
