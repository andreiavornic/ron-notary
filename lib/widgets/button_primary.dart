import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/methods/resize_formatting.dart';

class ButtonPrimary extends StatelessWidget {
  final Function callback;
  final String text;
  final double width;
  final bool activeBtn;

  ButtonPrimary({
    this.callback,
    this.text,
    this.width,
    this.activeBtn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: callback != null
              ? MaterialStateProperty.all(activeBtn != null && activeBtn
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.secondary)
              : MaterialStateProperty.all(
                  Color(0xFFD1D1D1),
                ),
          overlayColor: MaterialStateProperty.all(
            Color(0xFFFFFFFF).withOpacity(0.2),
          ),
          textStyle: MaterialStateProperty.all(
            TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 16,
              fontWeight: FontWeight.bold,

            ),
          ),
          padding: MaterialStateProperty.all(
            EdgeInsets.zero,
          ),
        ),
        onPressed: callback,
        child: SizedBox(
          height: reSize(51),
          width: width != null ? width : Get.width - 40,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 16,
                  color: activeBtn != null && activeBtn
                      ? Theme.of(context).colorScheme.secondary
                      : Color(0xFFFFFFFF)),
            ),
          ),
        ),
      ),
    );
  }
}
