import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notary/controllers/payment.dart';
import 'package:notary/controllers/plan.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/network_connection.dart';
import 'package:notary/widgets/payment_success.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../methods/resize_formatting.dart';
import '../methods/show_error.dart';
import '../utils/navigate.dart';
import '../widgets/button_primary.dart';
import '../widgets/plan_block.dart';
import '../widgets/title_page.dart';

class PurchaseCat extends StatefulWidget {
  @override
  State<PurchaseCat> createState() => _PurchaseCatState();
}

class _PurchaseCatState extends State<PurchaseCat> {
  List<Offering> _offerings = [];
  UserController _userController;
  PaymentController _paymentController;
  PlanController _planController;
  PageController pageController;
  int _indexPage;
  bool _loading;
  String _oldSKU;

  @override
  void initState() {
    _loading = true;
    _userController = Provider.of<UserController>(context, listen: false);
    _paymentController = Provider.of<PaymentController>(context, listen: false);
    _planController = Provider.of<PlanController>(context, listen: false);
    _indexPage = 1;
    pageController =
        PageController(viewportFraction: 0.8, initialPage: _indexPage);
    initPlatformState();
    super.initState();
  }

  @override
  void dispose()  {
    // await Purchases.logOut();
    Purchases.close();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    try {
      await Purchases.setDebugLogsEnabled(false);
      await _planController.getPlan();
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
      await _getAvailableProducts();
      _loading = false;
      setState(() {});
    } catch (err) {
      print(err);
      _loading = false;
      setState(() {});
    }
  }

  _getAvailableProducts() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        // Display current offering with offerings.current
      }
      offerings.all.forEach((key, value) {
        print(value);
        if (value.availablePackages[0].identifier != 'Extra Notarization') {
          _offerings.add(value);
        }
      });

      PurchaserInfo info = await Purchases.getPurchaserInfo();
      print("info.entitlements.all $info");
      if (info.entitlements.all['pro monthly'].isActive ||
          info.entitlements.active.isNotEmpty) {
        _oldSKU = info.entitlements.all['pro monthly'].productIdentifier;
        print("_oldSKU $_oldSKU");
      }
      setState(() {});
    } on PlatformException catch (e) {
      print("PlatformException $e");
      throw e;
    } catch (err) {
      throw err;
    }
  }

  _buyProduct() async {
    _loading = true;
    setState(() {});
    try {
      Package package = _offerings[_indexPage].availablePackages[0];
      PurchaserInfo purchaserInfo;
      print("_oldSKU $_oldSKU");
      if (_oldSKU != null && Platform.isAndroid) {
        UpgradeInfo _upgradeInfo = new UpgradeInfo(
          _oldSKU,
          prorationMode: ProrationMode.immediateWithoutProration,
        );
        print("_upgradeInfo $_upgradeInfo");

        purchaserInfo = await Purchases.purchasePackage(
          package,
          upgradeInfo: _upgradeInfo,
        );
      } else {
        purchaserInfo = await Purchases.purchasePackage(package);
      }

      if (purchaserInfo == null) {
        _loading = false;

        setState(() {});
        return;
      }
      _loading = false;
      setState(() {});
      StateM(context).navOff(
        PaymentSuccess(),
      );
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

  @override
  Widget build(BuildContext context) {
    return NetworkConnection(LoadingPage(
      _loading,
      Container(
        width: StateM(context).width(),
        height: StateM(context).height(),
        child: Column(
          children: [
            TitlePage(
              title: "Subscription Plan",
              description: "Select plan for your business needs",
              needNav: true,
            ),
            SizedBox(height: StateM(context).height() > 700 ? 30 : 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    width: 1,
                    color: Color(0xFF000000).withOpacity(0.14),
                  ),
                ),
                child: Container(
                    child: Padding(
                  padding: EdgeInsets.all(1),
                  child: Row(
                    children: [
                      if (_offerings.length > 0)
                        ..._offerings.asMap().entries.map((product) {
                          int index = product.key;
                          return Expanded(
                            child: InkWell(
                              onTap: () {
                                pageController.animateToPage(
                                  index,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOut,
                                );
                                _indexPage = index;
                                setState(() {});
                              },
                              child: Container(
                                height: reSize(context, 30),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: _indexPage == index
                                        ? Color(0xFFFFC600)
                                        : Colors.transparent),
                                child: Center(
                                  child: Text(product.value.identifier),
                                ),
                              ),
                            ),
                          );
                        })
                    ],
                  ),
                )),
              ),
            ),
            SizedBox(height: reSize(context, 30)),
            Expanded(
              child: PageView(
                controller: pageController,
                clipBehavior: Clip.none,
                onPageChanged: (int page) {
                  _indexPage = page;
                  setState(() {});
                },
                children: <Widget>[
                  if (_offerings.length > 0)
                    ..._offerings.asMap().entries.map((package) {
                      int index = package.key;
                      return PlanBlock(
                        indexPage: _indexPage,
                        indexBlock: index,
                        package: _offerings[index].availablePackages[0],
                        plan: _planController.plans.length > 0
                            ? _planController.plans?.firstWhere((element) =>
                                element.productId ==
                                _offerings[index]
                                    .availablePackages[0]
                                    .product
                                    .identifier)
                            : null,
                      );
                    }),
                ],
              ),
            ),
            SizedBox(height: reSize(context, 30)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ButtonPrimary(
                text: 'Subscribe',
                callback: _buyProduct,
              ),
            ),
            SizedBox(
              height: StateM(context).height() < 670 ? 20 : reSize(context, 40),
            ),
          ],
        ),
      ),
    ));
  }
}
