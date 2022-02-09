import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/views/select_plan.dart';
import 'package:notary/widgets/button_primary_outline.dart';

class PaymentBtn extends StatefulWidget {
  @override
  _PaymentBtnState createState() => _PaymentBtnState();
}

class _PaymentBtnState extends State<PaymentBtn> {
  // StreamSubscription<List<dynamic>> _subscription;

  @override
  initState() {
    // final Stream purchaseUpdated =
    //     InAppPurchaseConnection.instance.purchaseUpdatedStream;
    // _subscription = purchaseUpdated.listen((purchaseDetailsList) {
    //   print(purchaseDetailsList);
    // }, onDone: () {
    //   _subscription.cancel();
    // }, onError: (error) {
    //   print(error);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: reSize(80),
          height: reSize(80),
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
        SizedBox(height: reSize(30)),
        Text(
          "To start using Ronary please select\na subscription",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: reSize(30)),
        ButtonPrimaryOutline(
          callback: () => Get.to(
            () => SelectPlan(),
            transition: Transition.noTransition,
          ),
          text: "Choose Plan",
          width: 232,
        ),
      ],
    );
  }
}
