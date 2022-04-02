import 'package:flutter/material.dart';

class StateM {
  BuildContext context;

  StateM(ctx) {
    this.context = ctx;
  }

  void navBack() {
    Navigator.pop(context);
  }

  void navOff(Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration(seconds: 0),
      ),
    );
  }

  void navTo(Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration(seconds: 0),
      ),
    );
  }

  double width() {
    return MediaQuery.of(context).size.width;
  }

  double height() {
    return MediaQuery.of(context).size.height;
  }

  double devicePixelRatio() {
    return MediaQuery.of(context).devicePixelRatio;
  }
}
