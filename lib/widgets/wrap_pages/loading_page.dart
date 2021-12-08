import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      height: Get.height,
      child: Stack(
        children: [
          widget.widget,
          widget.isLoading
              ? Positioned(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
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
