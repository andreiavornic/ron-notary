import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notary/methods/resize_formatting.dart';

class Loading extends StatefulWidget {
  final Color colorBg;
  final String txt;

  Loading({this.colorBg, this.txt});

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/anime/loader7.json',
      width: reSize(context, 50),
      height: reSize(context, 50),
    );
  }
}
