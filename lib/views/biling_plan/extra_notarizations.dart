import 'dart:io';

// import 'package:adapty_flutter/adapty_flutter.dart';
// import 'package:adapty_flutter/models/adapty_paywall.dart';
// import 'package:adapty_flutter/models/adapty_product.dart';
// import 'package:adapty_flutter/results/get_paywalls_result.dart';
// import 'package:adapty_flutter/results/make_purchase_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:notary/controllers/user.dart';

// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

Set<String> extraId = <String>{"extra.ronary.com"};

class ExtraNotarization extends StatefulWidget {
  const ExtraNotarization({Key key}) : super(key: key);

  @override
  _ExtraNotarizationState createState() => _ExtraNotarizationState();
}

class _ExtraNotarizationState extends State<ExtraNotarization> {
  UserController _userController;
  int _extraNotarization;
  bool _loading;

  Offering _extraOffering;

  // List<ProductDetails> _products = [];

  @override
  void initState() {
    print("initState() => Executed!");
    _loading = false;
    _extraNotarization = 1;
    _userController = Provider.of<UserController>(context, listen: false);
    _initProduct();
    super.initState();
  }

  _initProduct() async {
    try {
      await Purchases.setDebugLogsEnabled(false);
      if (Platform.isAndroid) {
        await Purchases.setup("goog_DrHqiNSEIRjHlVmRtdUpnghhSSi");
      } else if (Platform.isIOS) {
        await Purchases.setup("appl_stCljdECnjoLyTdauyLLNGbhCQL");
      }
      Purchases.logIn(_userController.user.email);
      Purchases.setAttributes({
        "Name":
            "${_userController.user.lastName} ${_userController.user.firstName}",
        "E-mail": _userController.user.email,
        "Phone": _userController.user.phone,
      });
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.all['Extra Notarization'] != null) {
        _extraOffering = offerings.all['Extra Notarization'];
      }
      print(_extraOffering.availablePackages[0].identifier);
    } catch (err) {
      print(err);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _buyConsumable() async {
    try {
      _loading = true;
      setState(() {});
      print(_extraOffering);
      if (_extraOffering != null &&
          _extraOffering.availablePackages != null &&
          _extraOffering.availablePackages.length > 0) {
        await Purchases.purchasePackage(_extraOffering.availablePackages[0]);
      }
      _loading = false;
      setState(() {});
      // InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    } on PlatformException catch (e) {
      _loading = false;
      setState(() {});
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        showError(e, context);
      }
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err, context);
    }
  }

  void _minusExtra() {
    if (_extraNotarization > 1) {
      _extraNotarization -= 1;
      setState(() {});
    }
  }

  void _plusExtra() {
    if (_extraNotarization < 9) {
      _extraNotarization += 1;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: StateM(context).height() / 2,
      child: _loading
          ? Center(child: Loading())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: reSize(context, 30)),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: reSize(context, 20)),
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
                      SizedBox(height: reSize(context, 5)),
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
                SizedBox(height: reSize(context, 30)),
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
                                width: reSize(context, 32),
                                height: reSize(context, 32),
                                child: TextButton(
                                  onPressed: _extraNotarization <= 1
                                      ? null
                                      : _minusExtra,
                                  //  paymentProvider.minusNotarization(),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xFFE1E1E1)),
                                    overlayColor: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(0.2),
                                    ),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero),
                                  ),
                                  child: Container(
                                    width: reSize(context, 28),
                                    height: reSize(context, 28),
                                    child: Center(
                                      child: SvgPicture.asset(
                                          "assets/images/80.svg"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: reSize(context, 40)),
                            Container(
                              height: reSize(context, 60),
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(
                                    width: 1.0, color: Color(0xFFE1E1E1)),
                              )),
                              child: Center(
                                child: Text(
                                  _extraNotarization.toString(),
                                  style: TextStyle(
                                    fontSize: 48,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: reSize(context, 40)),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Container(
                                width: reSize(context, 32),
                                height: reSize(context, 32),
                                child: TextButton(
                                  onPressed: _plusExtra,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xFFE1E1E1)),
                                    overlayColor: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(0.2),
                                    ),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero),
                                  ),
                                  child: Container(
                                    width: reSize(context, 28),
                                    height: reSize(context, 28),
                                    child: Center(
                                      child: SvgPicture.asset(
                                          "assets/images/79.svg"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                SizedBox(height: reSize(context, 15)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                      width: StateM(context).width() - 40,
                      child: Text(
                        "Maximum 9 RON's",
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      )),
                ),
                SizedBox(height: reSize(context, 5)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ButtonPrimary(
                    text: "Buy for \$${_extraNotarization * 25}",
                    callback: _buyConsumable,
                  ),
                ),
                SizedBox(
                    height: StateM(context).height() < 670
                        ? 20
                        : reSize(context, 40)),
              ],
            ),
    );
  }
}
