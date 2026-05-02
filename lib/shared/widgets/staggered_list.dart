import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';

/// Wraps children in a staggered fade+slide animation.
///
/// Each child animates in with a configurable delay offset,
/// creating a cascading entrance effect for lists and forms.
class StaggeredList extends StatefulWidget {
  const StaggeredList({
    super.key,
    required this.children,
    this.staggerDelay = AppDurations.stagger,
    this.animationDuration = AppDurations.moderate,
    this.curve = AppDurations.entrance,
    this.slideOffset = 20.0,
  });

  final List<Widget> children;
  final Duration staggerDelay;
  final Duration animationDuration;
  final Curve curve;
  final double slideOffset;

  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final totalDuration = widget.animationDuration +
        widget.staggerDelay * widget.children.length;
    _controller = AnimationController(
      vsync: this,
      duration: totalDuration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalMs = _controller.duration!.inMilliseconds;
    final animMs = widget.animationDuration.inMilliseconds;
    final staggerMs = widget.staggerDelay.inMilliseconds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.children.length, (index) {
        final startMs = staggerMs * index;
        final begin = startMs / totalMs;
        final end = (startMs + animMs) / totalMs;

        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(
            begin.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
            curve: widget.curve,
          ),
        );

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: Transform.translate(
                offset: Offset(0, widget.slideOffset * (1 - animation.value)),
                child: child,
              ),
            );
          },
          child: widget.children[index],
        );
      }),
    );
  }
}

/// Simplified animated builder that works with [Animation].
class AnimatedBuilder extends AnimatedWidget {
  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
