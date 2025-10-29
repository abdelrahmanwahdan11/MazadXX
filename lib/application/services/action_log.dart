class ActionLog {
  ActionLog({this.capacity = 50});

  final int capacity;
  final List<String> _entries = <String>[];

  void add(String message) {
    if (_entries.length >= capacity) {
      _entries.removeAt(0);
    }
    _entries.add(message);
  }

  List<String> get entries => List.unmodifiable(_entries.reversed);
}
