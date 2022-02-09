import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:notary/views/start.dart';

import 'button_primary_outline.dart';

class PaymentSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(50)),
                child: Center(
                  child: SvgPicture.asset('assets/images/94.svg'),
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Perfect!",
                style: TextStyle(
                  color: Color(0xFF161617),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Your payment was successful! Your receipt has\nbeen emailed to you. Let's get some documents\nnotarized!",
                style: TextStyle(
                    color: Color(0xFF494949), fontSize: 14, height: 1.4),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              ButtonPrimaryOutline(
                width: 232,
                text: 'Homescreen',
                callback: () => Get.offAll(() => Start(), transition: Transition.noTransition),
              )
            ],
          ),
        ),
      ),
    );
  }
}
