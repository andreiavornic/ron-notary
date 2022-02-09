import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/widgets/button_primary_outline.dart';

import '../notary_edit.dart';

class NoNotary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (_controller) {
      return Column(
        children: [
          Container(
            width: reSize(96),
            height: reSize(96),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: SvgPicture.asset("assets/images/76.svg"),
            ),
          ),
          SizedBox(height: reSize(30)),
          Container(
            child: Text(
              "Before we begin, we require some\nadditional information",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: reSize(30)),
          Container(
            child: ButtonPrimaryOutline(
              text: "Add",
              callback: () => Get.to(
                () => NotaryEdit(),
              ),
              width: 232,
            ),
          ),
        ],
      );
    });
  }
}
