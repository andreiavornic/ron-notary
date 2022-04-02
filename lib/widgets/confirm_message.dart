import 'package:flutter/material.dart';

import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/utils/navigate.dart';

import 'button_primary_outline.dart';

class ConfirmMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Container(
        width: StateM(context).width(),
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
                    size: reSize(context, 50),
                  ),
                ),
              ),
              SizedBox(height: reSize(context, 20)),
              Text(
                "Thanks!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(height: reSize(context, 20)),
              Text(
                "Thank you for your message! You will\nreceive an email within 24 hours",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: reSize(context, 20)),
              ButtonPrimaryOutline(
                text: "Resume",
                callback: () => Navigator.pop(context),
                width: 232,
              )
            ],
          ),
        ),
      ),
    );
  }
}
