import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:notary/utils/navigate.dart';


import 'loading.dart';

class LoadingPage extends StatelessWidget {
  final bool isLoading;
  final Widget widget;

  LoadingPage(
    this.isLoading,
    this.widget,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Stack(
        children: [
          widget,
          isLoading
              ? Positioned(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Container(
                      width: StateM(context).width(),
                      height: StateM(context).height(),
                      child: Center(
                        child: Loading(),
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF).withOpacity(0.4),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
