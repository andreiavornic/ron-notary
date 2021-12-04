import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BtnSign extends StatelessWidget {
  final String icon;
  final Function callback;
  final bool isSigned;

  BtnSign({this.icon, this.callback, this.isSigned});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: isSigned ? Color(0xFFF5F6F9) : Theme.of(context).accentColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.zero,
            ),
            overlayColor: MaterialStateProperty.all(
              Theme.of(context).accentColor.withOpacity(0.05),
            ),
          ),
          child: Container(
            width: 42,
            height: 42,
            child: Center(
              child: Container(
                width: 26,
                height: 26,
                child: SvgPicture.asset(
                  "assets/images/$icon.svg",
                  color: isSigned ? Color(0xFFADAEAF) : Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
          onPressed: isSigned ? null : callback,
        ),
      ),
    );
  }
}
