import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:notary/controllers/user.dart';
import 'package:notary/methods/date_format.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/loading.dart';
import 'package:notary/widgets/modals/modal_container.dart';
import 'package:provider/provider.dart';
import '../../methods/show_error.dart';
import '../purchase_app.dart';
import '../purchase_cat.dart';
import 'extra_notarizations.dart';

class PlanCard extends StatefulWidget {
  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _getData();
  }

  _getData() async {
    try {
      await Provider.of<UserController>(context, listen: false).getUser();
      _isLoading = false;
      setState(() {});
    } catch (err) {
      _isLoading = false;
      setState(() {});
      showError(err, context);
    }
  }

  _getDate(int endPeriod) {
    int nowDate = DateTime.now().millisecondsSinceEpoch;
    if (endPeriod != null) {
      if (nowDate > endPeriod) {
        return "Expired in ${formatDate(endPeriod)}";
      } else {
        return "Exp: ${formatDate(endPeriod)}";
      }
    }
    return "Exp:";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(builder: (context, _controller, _) {
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
            child: _controller.payment == null || !_controller.payment.paid
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
                          SizedBox(height: reSize(context, 15)),
                          Text(
                            "To start using Ronary please select\nsubscription plan",
                            style: TextStyle(
                              color: Color(0xFFA8ABAB),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: reSize(context, 20)),
                          ButtonPrimary(
                            text: "Select Subscription",
                            activeBtn: true,
                            callback: () => StateM(context).navTo(
                              PurchaseApp(),
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
                                  "${_controller.payment.plan.title} ${_controller.payment.plan != null ? _controller.payment.plan.ronAmount : ""} RON",
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
                                      width: reSize(context, 5),
                                    ),
                                    Text(
                                      "${_controller.payment.ronAmount}",
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
                            SizedBox(height: reSize(context, 15)),
                            Container(
                              width: reSize(context, 77),
                              height: reSize(context, 24),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: TextButton(
                                  onPressed: () =>
                                      StateM(context).navTo(PurchaseApp()),
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
                                    width: reSize(context, 77),
                                    height: reSize(context, 24),
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
                                          SizedBox(width: reSize(context, 5)),
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
                            SizedBox(height: reSize(context, 20)),
                            Container(
                              height: 1,
                              color: Color(0xFF494949),
                            ),
                            SizedBox(height: reSize(context, 20)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_getDate(_controller.payment.endPeriod)}',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 12,
                                  ),
                                ),
                                // InkWell(
                                //   onTap: () => modalContainer(
                                //     ConfirmDelete(
                                //       callback: _deletePayment,
                                //       description: Text(
                                //         'You really want to unsubscribe? All your RON notarizations will be deleted, you will have 30 days to download your files',
                                //         style: TextStyle(
                                //           color: Color(0xFF494949),
                                //           fontSize: 14,
                                //         ),
                                //         textAlign: TextAlign.center,
                                //       ),
                                //       btnTxt: 'Unsubscribe',
                                //     ),
                                //   ),
                                //   child: Text(
                                //     "Unsubscribe",
                                //     style: TextStyle(
                                //       color: Color(0xFF878E8D),
                                //       fontSize: 12,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(height: reSize(context, 20)),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                height: reSize(context, 44),
                                width: StateM(context).width() -
                                    reSize(context, 60),
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
                                              .colorScheme
                                              .secondary
                                              .withOpacity(0.05)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Theme.of(context).primaryColor),
                                    ),
                                    onPressed: ()=> print("Add extra notarization"),
                                    // onPressed: _addExtra,
                                    // onPressed: () => modalContainerSimple(
                                    //     ExtraNotarization(), context),
                                    child: Text(
                                      "Buy extra notarization",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
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
                  width: StateM(context).width() - 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.7),
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
}
