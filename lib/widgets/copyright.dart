import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/views/policy.dart';

class Copyright extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: new RichText(
          textAlign: TextAlign.center,
          text: new TextSpan(
            children: [
              new TextSpan(
                  text: 'Ronary Privacy Policy \n',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF494949),
                  ),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () => Get.to(
                          () => PolicyView(),
                          transition: Transition.noTransition,
                        )),
              new TextSpan(
                text: 'explains the use of your personal data',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFA4A4A4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
