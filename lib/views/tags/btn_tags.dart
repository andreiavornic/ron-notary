import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:notary/methods/resize_formatting.dart';

class BtnTags extends StatelessWidget {
  final Color baseColor;
  final Function callback;
  final String icon;
  final String text;
  final bool active;

  BtnTags({
    this.baseColor,
    this.callback,
    this.icon,
    this.text,
    this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: TextButton(
        onPressed: callback,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          overlayColor: MaterialStateProperty.all(
            baseColor.withOpacity(0.15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon != null
                ? SvgPicture.asset(
                    icon,
                    width: reSize(24),
                    color: active != null && active
                        ? baseColor
                        : Color(0xFF494949),
                  )
                : Icon(
                    FontAwesomeIcons.stamp,
                    size: reSize(14),
                    color: active != null && active
                        ? baseColor
                        : Color(0xFF494949),
                  ),
            SizedBox(height: reSize(2)),
            Container(
              width: Get.width,
              child: Text(
                text,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      active != null && active ? baseColor : Color(0xFF494949),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
