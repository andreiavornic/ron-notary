import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/payment.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/date_format.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/models/payment.dart';
import 'package:notary/views/process/confirm_delete.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/loading.dart';
import 'package:notary/widgets/modals/modal_container.dart';

import '../select_plan.dart';

class PlanCard extends StatefulWidget {
  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  PaymentController _paymentController = Get.put(PaymentController());
  UserController _userController = Get.put(UserController());
  bool _isLoading;


  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }


  Future<void> _deletePayment() async {
    _isLoading = true;
    setState(() {});
    Get.back();
    try {
      await _paymentController.deletePayment();
      _userController.deletePayment();
      _isLoading = false;
      setState(() {});
    } catch (err) {
      _isLoading = false;
      setState(() {});
      showError(err);
    }
  }

  Future<void> _addExtra() async {
    try {
      await _paymentController.selectExtraNotarization();
      await _userController
          .addExtra(_paymentController.extraNotarization.value);
      Get.back();
      // await FlutterInappPurchase.instance
      //     .requestPurchaseWithQuantityIOS(_item.productId, 5);
    } catch (err) {
      showError(err);
    }
  }

  _getDate(int endPeriod) {
    if (endPeriod != null) return formatDate(endPeriod);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (_controller) {
      Payment payment = _controller.payment.value;
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF272D2C), Color(0xFF272D2C)],
              ),
            ),
            child: payment == null || !payment.paid
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.1, 0.9],
                        colors: [
                          Color(0xFF343A39),
                          Color(0xFF272D2C),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Subscription Plan",
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: reSize(15)),
                          Text(
                            "To start using Ronary please select\nsubscription plan",
                            style: TextStyle(
                              color: Color(0xFFA8ABAB),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: reSize(20)),
                          ButtonPrimary(
                            text: "Select Subscription",
                            activeBtn: true,
                            callback: () => Get.to(() => SelectPlan()
                                //   Navigator.push(
                                // context,
                                // MaterialPageRoute(
                                //   builder: (context) => SelectPlan(
                                //     cards: widget.user?.payment?.cards,
                                //   ),
                                // ),
                                //),
                                ),
                          )
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${payment.plan.title} ${payment.plan != null ? payment.plan.ronAmount : ""} RON",
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Left:",
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      width: reSize(5),
                                    ),
                                    Text(
                                      "${payment.ronAmount}",
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: reSize(15)),
                            Container(
                              width: reSize(77),
                              height: reSize(24),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: TextButton(
                                  onPressed: () => Get.to(() => SelectPlan()),
                                  //   Navigator.push(
                                  // context,
                                  // MaterialPageRoute(
                                  //   builder: (context) => SelectPlan(
                                  //     cards: widget.user.value.cards,
                                  //     changePlan: true,
                                  //     planId: widget.user.value.payment.plan.id,
                                  //   ),
                                  // ),
                                  //),
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.zero),
                                      overlayColor: MaterialStateProperty.all(
                                        Color(0xFFFFFFFF).withOpacity(0.1),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color(0xFF494949))),
                                  child: Container(
                                    width: reSize(77),
                                    height: reSize(24),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/78.svg",
                                            color: Color(0xFFFFFFFF),
                                          ),
                                          SizedBox(width: reSize(5)),
                                          Text(
                                            "Change",
                                            style: TextStyle(
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: reSize(20)),
                            Container(
                              height: 1,
                              color: Color(0xFF494949),
                            ),
                            SizedBox(height: reSize(20)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Exp: ${_getDate(payment.endPeriod)}',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 12,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => modalContainer(
                                    ConfirmDelete(
                                      callback: _deletePayment,
                                      description: Text(
                                        'You really want to unsubscribe? All your RON notarizations will be deleted, you will have 30 days to download your files',
                                        style: TextStyle(
                                          color: Color(0xFF494949),
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      btnTxt: 'Unsubscribe',
                                    ),
                                  ),
                                  child: Text(
                                    "Unsubscribe",
                                    style: TextStyle(
                                      color: Color(0xFF878E8D),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: reSize(20)),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                height: reSize(44),
                                width: Get.width - reSize(60),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: TextButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.zero),
                                      overlayColor: MaterialStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme.secondary
                                              .withOpacity(0.05)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Theme.of(context).primaryColor),
                                    ),
                                    // onPressed: _addExtra,
                                    onPressed: () =>
                                        modalContainer(_extraSet(1)),
                                    child: Text(
                                      "Buy extra notarization",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          _isLoading
              ? Container(
                  height: 231,
                  width: Get.width - 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Loading(),
                  ),
                )
              : Container()
        ],
      );
    });
  }

  void _plusExtra() {
    _paymentController.plusExtra();
    setState(() {});
  }

  void _minusExtra() {
    _paymentController.minusExtra();
    setState(() {});
  }

  Widget _extraSet(int ron) {
    return GetBuilder<PaymentController>(builder: (_controller) {
      return Container(
        height: Get.height / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: reSize(30)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: reSize(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Buy RON Sessions",
                    style: TextStyle(
                      color: Color(0xFF161617),
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: reSize(5)),
                  Text(
                    "Select number of RON credits",
                    style: TextStyle(
                      color: Color(0xFFADAEAF),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: reSize(30)),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Container(
                            width: reSize(28),
                            height: reSize(28),
                            child: TextButton(
                              onPressed: _controller.extraNotarization <= 1
                                  ? null
                                  : _minusExtra,
                              //  paymentProvider.minusNotarization(),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFE1E1E1)),
                                overlayColor: MaterialStateProperty.all(
                                  Theme.of(context)
                                      .colorScheme.secondary
                                      .withOpacity(0.2),
                                ),
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero),
                              ),
                              child: Container(
                                width: reSize(28),
                                height: reSize(28),
                                child: Center(
                                  child:
                                      SvgPicture.asset("assets/images/80.svg"),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: reSize(40)),
                        Container(
                          height: reSize(60),
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(
                                width: 1.0, color: Color(0xFFE1E1E1)),
                          )),
                          child: Center(
                            child: Text(
                              _paymentController.extraNotarization.toString(),
                              style: TextStyle(
                                fontSize: 48,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: reSize(40)),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Container(
                            width: reSize(28),
                            height: reSize(28),
                            child: TextButton(
                              onPressed: _plusExtra,
                              // paymentProvider.addNotarization(),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFE1E1E1)),
                                overlayColor: MaterialStateProperty.all(
                                  Theme.of(context)
                                      .colorScheme.secondary
                                      .withOpacity(0.2),
                                ),
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero),
                              ),
                              child: Container(
                                width: reSize(28),
                                height: reSize(28),
                                child: Center(
                                  child:
                                      SvgPicture.asset("assets/images/79.svg"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            SizedBox(height: reSize(20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ButtonPrimary(
                text: "Buy for \$${_controller.extraNotarization * 25}",
                callback: _addExtra,
              ),
            ),
            SizedBox(height: Get.height < 670 ? 20 : reSize(40)),
          ],
        ),
      );
    });
  }
}
