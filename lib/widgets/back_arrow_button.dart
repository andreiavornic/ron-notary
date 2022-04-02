import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:notary/methods/resize_formatting.dart';

class BackArrowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //  SizedBox(height: 4),
        InkWell(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: reSize(context, 50),
            height: reSize(context, 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 4),
                SvgPicture.asset("assets/images/96.svg"),
              ],
            )),
          ),
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
