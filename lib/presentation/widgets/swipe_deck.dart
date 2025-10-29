import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef SwipeDeckBuilder<T> = Widget Function(BuildContext context, T item);
typedef SwipeAction<T> = void Function(T item);

class SwipeDeck<T> extends StatefulWidget {
  const SwipeDeck({
    super.key,
    required this.items,
    required this.builder,
    this.onLike,
    this.onPass,
    this.onInfo,
  });

  final List<T> items;
  final SwipeDeckBuilder<T> builder;
  final SwipeAction<T>? onLike;
  final SwipeAction<T>? onPass;
  final SwipeAction<T>? onInfo;

  @override
  State<SwipeDeck<T>> createState() => _SwipeDeckState<T>();
}

class _SwipeDeckState<T> extends State<SwipeDeck<T>> with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _index = ValueNotifier<int>(0);
  Offset _offset = Offset.zero;
  double _rotation = 0;

  @override
  void dispose() {
    _index.dispose();
    super.dispose();
  }

  void _resetPosition() {
    setState(() {
      _offset = Offset.zero;
      _rotation = 0;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _offset += details.delta;
      _rotation = (_offset.dx / 250).clamp(-0.2, 0.2);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dx;
    final decision = _decide(velocity, _offset.dx);
    if (decision == _SwipeDecision.none) {
      _resetPosition();
      return;
    }
    final index = _index.value;
    if (index >= widget.items.length) {
      _resetPosition();
      return;
    }
    final item = widget.items[index];
    if (decision == _SwipeDecision.like) {
      widget.onLike?.call(item);
    } else if (decision == _SwipeDecision.pass) {
      widget.onPass?.call(item);
    }
    setState(() {
      _index.value = math.min(index + 1, widget.items.length);
      _offset = Offset.zero;
      _rotation = 0;
    });
  }

  _SwipeDecision _decide(double velocity, double offset) {
    if (velocity > 800 || offset > 140) {
      return _SwipeDecision.like;
    }
    if (velocity < -800 || offset < -140) {
      return _SwipeDecision.pass;
    }
    return _SwipeDecision.none;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _index,
      builder: (BuildContext context, int index, _) {
        if (index >= widget.items.length) {
          return Center(child: Text('empty_state'.tr));
        }
        final item = widget.items[index];
        final nextItem = index + 1 < widget.items.length ? widget.items[index + 1] : null;
        return Stack(
          alignment: Alignment.center,
          children: [
            if (nextItem != null)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                top: 24,
                child: Transform.scale(
                  scale: 0.95,
                  child: Opacity(
                    opacity: 0.4,
                    child: widget.builder(context, nextItem),
                  ),
                ),
              ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              top: 0,
              left: _offset.dx,
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 180),
                turns: _rotation / math.pi,
                child: GestureDetector(
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  onTap: () => widget.onInfo?.call(item),
                  child: widget.builder(context, item),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: _SwipeHint(
                icon: Icons.close,
                alignment: Alignment.centerLeft,
                highlight: _offset.dx < -60,
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: _SwipeHint(
                icon: Icons.favorite,
                alignment: Alignment.centerRight,
                highlight: _offset.dx > 60,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SwipeHint extends StatelessWidget {
  const _SwipeHint({
    required this.icon,
    required this.alignment,
    required this.highlight,
  });

  final IconData icon;
  final Alignment alignment;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 150),
      scale: highlight ? 1.1 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: highlight ? Theme.of(context).colorScheme.primary.withOpacity(0.15) : Colors.black12,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: highlight ? Theme.of(context).colorScheme.primary : Colors.white),
        ),
      ),
    );
  }
}

enum _SwipeDecision { like, pass, none }
