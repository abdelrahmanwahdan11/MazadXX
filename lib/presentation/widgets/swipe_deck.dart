import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef SwipeCallback<T> = void Function(T item);

enum SwipeDecision { left, right, none }

class SwipeDeck<T> extends StatefulWidget {
  const SwipeDeck({
    super.key,
    required this.items,
    required this.builder,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item) builder;
  final SwipeCallback<T>? onSwipeLeft;
  final SwipeCallback<T>? onSwipeRight;

  @override
  State<SwipeDeck<T>> createState() => _SwipeDeckState<T>();
}

class _SwipeDeckState<T> extends State<SwipeDeck<T>> with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _index = ValueNotifier<int>(0);
  Offset _dragOffset = Offset.zero;
  double _rotation = 0;

  @override
  void dispose() {
    _index.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
      _rotation = (_dragOffset.dx / 300).clamp(-0.2, 0.2);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dx;
    final decision = _decideSwipe(velocity, _dragOffset.dx);
    if (decision == SwipeDecision.none) {
      setState(() {
        _dragOffset = Offset.zero;
        _rotation = 0;
      });
      return;
    }
    final currentIndex = _index.value;
    if (currentIndex >= widget.items.length) {
      return;
    }
    final item = widget.items[currentIndex];
    if (decision == SwipeDecision.left) {
      widget.onSwipeLeft?.call(item);
    } else if (decision == SwipeDecision.right) {
      widget.onSwipeRight?.call(item);
    }
    setState(() {
      _dragOffset = Offset.zero;
      _rotation = 0;
      _index.value = math.min(currentIndex + 1, widget.items.length);
    });
  }

  SwipeDecision _decideSwipe(double velocity, double offset) {
    if (velocity > 800 || offset > 120) {
      return SwipeDecision.right;
    }
    if (velocity < -800 || offset < -120) {
      return SwipeDecision.left;
    }
    return SwipeDecision.none;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _index,
      builder: (context, index, _) {
        if (index >= widget.items.length) {
          return Center(child: Text('empty_state'.tr));
        }
        final topItem = widget.items[index];
        final nextItem = index + 1 < widget.items.length ? widget.items[index + 1] : null;
        return Stack(
          alignment: Alignment.center,
          children: [
            if (nextItem != null)
              Transform.scale(
                scale: 0.95,
                child: Opacity(
                  opacity: 0.5,
                  child: widget.builder(context, nextItem),
                ),
              ),
            Transform.translate(
              offset: _dragOffset,
              child: Transform.rotate(
                angle: _rotation,
                child: GestureDetector(
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: widget.builder(context, topItem),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
