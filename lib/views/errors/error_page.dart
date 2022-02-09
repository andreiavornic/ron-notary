import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/widgets/button_primary_outline.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;
  final Function callback;

  ErrorPage({
    @required this.errorMessage,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: Get.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: reSize(96),
                      height: reSize(96),
                      decoration: BoxDecoration(
                        color: Color(0xFFFC563D),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: SvgPicture.asset('assets/images/107.svg'),
                      ),
                    ),
                    SizedBox(
                      height: reSize(30),
                    ),
                    Text(
                      "Declined",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: reSize(25),
                    ),
                    Text(
                      errorMessage,
                      style: TextStyle(
                        color: Color(0xFF494949),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: reSize(40),
                    ),
                    ButtonPrimaryOutline(
                      callback: callback,
                      text: "Go Back",
                      width: 232,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
