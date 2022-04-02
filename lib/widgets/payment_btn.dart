import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/purchase_cat.dart';
import 'package:notary/widgets/button_primary_outline.dart';

import '../views/purchase_app.dart';

class PaymentBtn extends StatefulWidget {
  @override
  _PaymentBtnState createState() => _PaymentBtnState();
}

class _PaymentBtnState extends State<PaymentBtn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: reSize(context, 80),
          height: reSize(context, 80),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/images/100.svg',
            ),
          ),
        ),
        SizedBox(height: reSize(context, 30)),
        Text(
          "To start using Ronary please select\na subscription",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: reSize(context, 30)),
        ButtonPrimaryOutline(
          callback: () => StateM(context).navTo(PurchaseApp()),
          text: "Choose Plan",
          width: 232,
        ),
      ],
    );
  }
}
