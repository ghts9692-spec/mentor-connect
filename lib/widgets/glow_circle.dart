import 'dart:ui';
import 'package:flutter/material.dart';

/// Soft blurred glow circle used as background decoration.
/// Shared across all screens for consistent visual effects.
class GlowCircle extends StatelessWidget {
  final Color color;
  final double size;

  const GlowCircle({super.key, required this.color, this.size = 260});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
