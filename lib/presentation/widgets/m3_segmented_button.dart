import 'package:flutter/material.dart';

class M3SegmentedButton<T> extends StatelessWidget {
  const M3SegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  final Map<T, String> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: segments.entries
          .map(
            (MapEntry<T, String> entry) => ButtonSegment<T>(
              value: entry.key,
              label: Text(entry.value),
            ),
          )
          .toList(),
      selected: <T>{selected},
      onSelectionChanged: (Set<T> value) {
        if (value.isNotEmpty) {
          onChanged(value.first);
        }
      },
    );
  }
}
