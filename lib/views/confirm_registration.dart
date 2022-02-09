import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:notary/widgets/button_primary_outline.dart';
import 'package:notary/widgets/copyright.dart';
import 'package:notary/widgets/recovered.dart';

class ConfirmRegistration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/98.svg',
                          width: 35,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Complete!',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF000000),
                        // letterSpacing: -1.5,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Text(
                        'Thank you for registering! Activation code has been sent to your email.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF414141),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: ButtonPrimaryOutline(
                          callback: () => Get.to(
                            () => RecoveredPage(isRegister: true),
                            transition: Transition.noTransition,
                          ),
                          text: 'Enter Code',
                          width: 163,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Copyright()
          ],
        ),
      ),
    );
  }
}
