// import 'package:adapty_flutter/adapty_flutter.dart';
// import 'package:adapty_flutter/models/adapty_android_subscription_update_params.dart';
// import 'package:adapty_flutter/models/adapty_enums.dart';
// import 'package:adapty_flutter/models/adapty_error.dart';
// import 'package:adapty_flutter/models/adapty_paywall.dart';
// import 'package:adapty_flutter/models/adapty_product.dart';
// import 'package:adapty_flutter/models/adapty_purchaser_info.dart';
// import 'package:adapty_flutter/models/adapty_subscription_info.dart';
// import 'package:adapty_flutter/results/get_paywalls_result.dart';
// import 'package:adapty_flutter/results/make_purchase_result.dart';
import 'package:flutter/material.dart';
import 'package:notary/widgets/loading_page.dart';

import '../methods/resize_formatting.dart';
import '../utils/navigate.dart';
import '../widgets/button_primary.dart';
import '../widgets/network_connection.dart';
import '../widgets/title_page.dart';

class PurchaseAdapty extends StatefulWidget {
  @override
  State<PurchaseAdapty> createState() => _PurchaseAdaptyState();
}

class _PurchaseAdaptyState extends State<PurchaseAdapty> {
  int _indexPage;
  // List<AdaptyProduct> _products = [];
  bool _loading;
  PageController pageController;
  // AdaptySubscriptionInfo _oldSubscription;

  @override
  void initState() {
    _indexPage = 1;
    pageController =
        PageController(viewportFraction: 0.8, initialPage: _indexPage);
    // _products = [];
    _loading = true;
    // _getPlan();
    // _initAdapty();
    super.initState();
  }

  // _initAdapty() async {
  //   try {
  //     _loading = true;
  //     _products = [];
  //     _getLastSubscription();
  //     setState(() {});
  //     Adapty.activate();

  //     await Adapty.setLogLevel(AdaptyLogLevel.errors);
  //     await Adapty.identify(_userController.user.email);

  //     final GetPaywallsResult getPaywallsResult =
  //         await Adapty.getPaywalls(forceUpdate: true);
  //     final List<AdaptyPaywall> paywalls = getPaywallsResult.paywalls;

  //     paywalls[0].products.forEach((product) {
  //       _products.add(product);
  //     });
  //     _loading = false;
  //     setState(() {});
  //   } on AdaptyError catch (adaptyError) {
  //     print("adaptyError error $adaptyError");
  //     _loading = false;
  //     setState(() {});
  //   } catch (e) {
  //     print("Catch error ${e.toString()}");
  //     _loading = false;
  //     setState(() {});
  //   }
  // }

  // _getPlan() async {
  //   try {
  //     await _planController.getPlan();
  //   } catch (err) {
  //     showError(err, context);
  //   }
  // }

  // _getLastSubscription() async {
  //   try {
  //     AdaptyPurchaserInfo purchaserInfo =
  //         await Adapty.getPurchaserInfo(forceUpdate: true);
  //     purchaserInfo.subscriptions.forEach((key, value) {
  //       if (value.isActive) {
  //         _oldSubscription = value;
  //         setState(() {});
  //       }
  //     });
  //   } on AdaptyError catch (adaptyError) {
  //     print("adaptyError error $adaptyError");
  //   } catch (e) {
  //     print("Catch error ${e.toString()}");
  //   }
  // }

  _buyProduct() async {
    // try {
    //   AdaptyProduct product = _products[_indexPage];
    //   _loading = true;
    //   setState(() {});
    //
    //   AdaptyAndroidSubscriptionUpdateParams subscriptionUpdateParams;
    //
    //   if (_oldSubscription != null) {
    //     subscriptionUpdateParams = new AdaptyAndroidSubscriptionUpdateParams(
    //       _oldSubscription.vendorProductId,
    //       AdaptyAndroidSubscriptionUpdateProrationMode.deferred,
    //     );
    //   }
    //
    //   final MakePurchaseResult makePurchaseResult = await Adapty.makePurchase(
    //     product,
    //     subscriptionUpdateParams: subscriptionUpdateParams,
    //   );
    //   if (makePurchaseResult.purchaserInfo?.accessLevels['premium']?.isActive ??
    //       false) {
    //     await _paymentController.verifyPayment(
    //         makePurchaseResult.purchaseToken, product.vendorProductId);
    //
    //     StateM(context).navOff(PaymentSuccess());
    //   }
    //   _loading = false;
    //   setState(() {});
    //   // if (makePurchaseResult.purchaserInfo?.accessLevels['premium']?.isActive ?? false) {
    //   //   // grant access to premium features
    //   // }
    // } catch (err) {
    //   _loading = false;
    //   setState(() {});
    //   print(err);
    // }
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
                          // ..._products.asMap().entries.map((product) {
                          //   int index = product.key;
                          //   return Expanded(
                          //     child: InkWell(
                          //       onTap: () {
                          //         pageController.animateToPage(
                          //           index,
                          //           duration: const Duration(seconds: 1),
                          //           curve: Curves.easeInOut,
                          //         );
                          //         _indexPage = index;
                          //         setState(() {});
                          //       },
                          //       child: Container(
                          //         height: reSize(context, 30),
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(2),
                          //             color: _indexPage == index
                          //                 ? Color(0xFFFFC600)
                          //                 : Colors.transparent),
                          //         child: Center(
                          //           child: Text(product.value.localizedTitle
                          //               .replaceAll('(Notary)', '')),
                          //         ),
                          //       ),
                          //     ),
                          //   );
                          // }),
                        ],
                      ),
                    ),
                  ),
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
                  // children: <Widget>[
                  //   ..._products.asMap().entries.map((package) {
                  //     int index = package.key;
                  //     return PlanBlock(
                  //       indexPage: _indexPage,
                  //       indexBlock: index,
                  //       product: _products[index],
                  //       plan: _planController.plans.length > 0
                  //           ? _planController.plans.firstWhere((element) =>
                  //               element.productId ==
                  //               _products[index].vendorProductId)
                  //           : null,
                  //     );
                  //     // return Container(
                  //     //   child: Padding(
                  //     //     padding: const EdgeInsets.symmetric(horizontal: 20),
                  //     //     child: Column(
                  //     //       children: [
                  //     //         Text(product.value.title),
                  //     //         Text(product.value.description),
                  //     //         Text(product.value.priceString),
                  //     //         SizedBox(
                  //     //           height: 10,
                  //     //         ),
                  //     //         TextButton(
                  //     //             //  onPressed: () => _buyProduct(product),
                  //     //             onPressed: _userController.payment != null &&
                  //     //                     _userController
                  //     //                             .payment.plan.productId ==
                  //     //                         product.value.identifier
                  //     //                 ? null
                  //     //                 : () => _buyProduct(product.value),
                  //     //             child: Text("Buy")),
                  //     //         Container(
                  //     //           color: Color(0xFFCCCCCC),
                  //     //           height: 1,
                  //     //         ),
                  //     //         SizedBox(
                  //     //           height: 10,
                  //     //         ),
                  //     //       ],
                  //     //     ),
                  //     //   ),
                  //     // );
                  //   }),
                  // ],
                ),
              ),
              SizedBox(height: reSize(context, 30)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ButtonPrimary(
                  text: 'Subscribe',
                  // callback: _products.length == 0 ||
                  //         _userController.payment != null &&
                  //             _userController.payment.plan.productId ==
                  //                 _products[_indexPage].identifier
                  //     ? null
                  //     : () => _buyProduct(_products[_indexPage]),
                  callback: _buyProduct,
                ),
              ),
              SizedBox(
                height:
                    StateM(context).height() < 670 ? 20 : reSize(context, 40),
              ),
            ],
          ),
        )));
  }
}
