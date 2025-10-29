class SavedFilter {
  const SavedFilter({
    required this.id,
    required this.scope,
    required this.payload,
    required this.label,
  });

  final String id;
  final String scope;
  final Map<String, dynamic> payload;
  final String label;
}
