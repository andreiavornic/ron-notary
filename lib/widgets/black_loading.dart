import 'package:flutter/material.dart';

import 'gradient_indicator.dart';

class BlackLoading extends StatefulWidget {
  final Color colorBg;
  final String txt;

  BlackLoading({this.colorBg, this.txt});

  @override
  _BlackLoadingState createState() => _BlackLoadingState();
}

class _BlackLoadingState extends State<BlackLoading> with SingleTickerProviderStateMixin {
  AnimationController rotationController;

  @override
  void initState() {
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
      child: GradientCircularProgressIndicator(
        radius: 15,
        gradientColors: [
          Color(0xFF000000).withOpacity(0),
          Color(0xFF000000).withOpacity(0.13),
          Color(0xFF000000),
        ],
        strokeWidth: 2.5,
      ),
    );

  }
}




