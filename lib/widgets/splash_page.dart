import 'package:flutter/material.dart';
import 'package:notary/utils/navigate.dart';


import '../widgets/loading.dart';

class SplashPage extends StatelessWidget {
  final widget;
  const SplashPage({this.widget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Container(
        width: StateM(context).width(),
        height: StateM(context).height(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 128,
                width: 128,
                child: Stack(
                  children: [Loading(), widget != null ? widget : Container()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
