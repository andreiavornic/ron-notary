import 'package:flutter/material.dart';

// import 'gradient_indicator.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatefulWidget {
  final Color colorBg;
  final String txt;

  Loading({this.colorBg, this.txt});

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  // AnimationController rotationController;
  AnimationController _controller;

  @override
  void initState() {
    // rotationController = AnimationController(
    //     duration: const Duration(milliseconds: 1000), vsync: this)
    //   ..repeat();
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // rotationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/anime/loader7.json',
      // return Lottie.network(
      //   'https://assets8.lottiefiles.com/packages/lf20_2m2ivxwg.json',
      width: 50,
      height: 50,
      // controller: _controller,
      // repeat: true,
      // onLoaded: (composition) {
      //   // Configure the AnimationController with the duration of the
      //   // Lottie file and start the animation.
      //   _controller
      //     ..duration = composition.duration
      //     ..forward();
      // },
    );
    // return RotationTransition(
    //   turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
    //   child: GradientCircularProgressIndicator(
    //     radius: 19,
    //     gradientColors: [
    //       Color(0xFFC8D1FF).withOpacity(0),
    //       Color(0xFFFF6B00),
    //       Color(0xFFFFC700),
    //     ],
    //     strokeWidth: 3,
    //   ),
    // );
  }
}
