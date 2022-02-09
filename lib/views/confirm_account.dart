import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/widgets/button_primary_outline.dart';

import 'auth.dart';

class ConfirmAccount extends StatefulWidget {
  @override
  _ConfirmAccountState createState() => _ConfirmAccountState();
}

class _ConfirmAccountState extends State<ConfirmAccount> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Container(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 96,
                width: 96,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Icon(
                    Icons.check,
                    size: 50,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Thanks!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "We successfully confirmed your account.\nLets finish your account set up.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20),
              ButtonPrimaryOutline(
                text: "My Account",
                callback: () => Get.offAll(
                  () => Auth(),
                  transition: Transition.noTransition,
                ),
                width: 232,
              )
            ],
          ),
        ),
      ),
    );
  }
}
