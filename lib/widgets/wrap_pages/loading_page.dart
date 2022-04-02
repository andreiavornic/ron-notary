import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:notary/utils/navigate.dart';


import '../loading.dart';

class LoadingPage extends StatefulWidget {
  final bool isLoading;
  final Widget widget;

  LoadingPage(this.isLoading, this.widget);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: StateM(context).height(),
      child: Stack(
        children: [
          widget.widget,
          widget.isLoading
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
