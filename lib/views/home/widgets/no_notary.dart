import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/widgets/button_primary_outline.dart';
import 'package:provider/provider.dart';

import '../notary_edit.dart';

class NoNotary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(builder: (context, _controller, _) {
      return Column(
        children: [
          Container(
            width: reSize(context, 96),
            height: reSize(context, 96),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: SvgPicture.asset("assets/images/76.svg"),
            ),
          ),
          SizedBox(height: reSize(context, 30)),
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
          SizedBox(height: reSize(context, 30)),
          Container(
            child: ButtonPrimaryOutline(
              text: "Add",
              callback: () => StateM(context).navTo(NotaryEdit()),
              width: 232,
            ),
          ),
        ],
      );
    });
  }
}
