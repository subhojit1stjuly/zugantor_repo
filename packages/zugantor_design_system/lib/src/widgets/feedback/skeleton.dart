// ignore_for_file: prefer_initializing_formals
import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A skeleton/shimmer loading placeholder for the ZDS design system.
///
/// Use while content is loading to give users a visual indication that
/// something is about to appear, reducing perceived load time.
///
/// ```dart
/// // A rectangle placeholder (e.g., for a card)
/// const ZDSSkeleton(width: 300, height: 120)
///
/// // A text line placeholder
/// const ZDSSkeleton.text(width: 200)
///
/// // A circular avatar placeholder
/// const ZDSSkeleton.circle(diameter: 48)
/// ```
class ZDSSkeleton extends StatefulWidget {
  /// Creates a rectangular skeleton placeholder.
  const ZDSSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  }) : diameter = null;

  /// Creates a single text-line placeholder.
  const ZDSSkeleton.text({
    super.key,
    this.width,
  })  : height = 14,
        borderRadius = const BorderRadius.all(Radius.circular(4)),
        diameter = null;

  /// Creates a circular placeholder (for avatars, icons).
  const ZDSSkeleton.circle({
    super.key,
    required double diameter,
  })  : diameter = diameter,
        width = diameter,
        height = diameter,
        borderRadius = null;

  /// Width of the skeleton. Fills parent when null.
  final double? width;

  /// Height of the skeleton.
  final double height;

  /// Corner radius override. Defaults to the ZDS small radius.
  final BorderRadius? borderRadius;

  /// When set, overrides both width and height for a circle shape.
  final double? diameter;

  @override
  State<ZDSSkeleton> createState() => _ZDSSkeletonState();
}

class _ZDSSkeletonState extends State<ZDSSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _shimmer = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor =
        isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
    final highlightColor =
        isDark ? const Color(0xFF3D3D3D) : const Color(0xFFF5F5F5);

    final radius = widget.diameter != null
        ? BorderRadius.circular(widget.diameter! / 2)
        : (widget.borderRadius ?? theme.shapes.smallRadius);

    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                (_shimmer.value - 0.3).clamp(0.0, 1.0),
                _shimmer.value.clamp(0.0, 1.0),
                (_shimmer.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
