import 'package:flutter/material.dart';

import 'gradient_painter.dart';

class GradientCircularProgressIndicator extends StatelessWidget {
  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;

  GradientCircularProgressIndicator({
    @required this.radius,
    @required this.gradientColors,
    this.strokeWidth = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(radius),
      painter: GradientCircularProgressPainter(
        radius: radius,
        gradientColors: gradientColors,
        strokeWidth: strokeWidth,
      ),
    );
  }
}