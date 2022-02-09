import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:notary/controllers/plan.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/plan_block.dart';
import 'package:notary/widgets/title_page.dart';

//import for AppStoreProductDetails
//import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

//import for SKProductWrapper
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class ChoosePlan extends StatefulWidget {
  final bool changePlan;

  ChoosePlan({
    this.changePlan,
  });

  @override
  _ChoosePlanState createState() => _ChoosePlanState();
}

class _ChoosePlanState extends State<ChoosePlan> {
  PageController pageController;
  int _indexPage;
  double _heightMedia;
  PlanController _planController = Get.put(PlanController());

  List<ProductDetails> _items = [];

  bool _loading;

  StreamSubscription<List<PurchaseDetails>> _subscription;

  final Set<String> _productLists = Platform.isAndroid
      ? {}
      : {'basic.ronary.com', 'business.ronary.com', 'pro.ronary.com'};

  initState() {
    _loading = true;
    _indexPage = 1;
    pageController =
        PageController(viewportFraction: 0.8, initialPage: _indexPage);
    //_planController.getPlan();

    _getPlans();
    loadProducts();
    initPlatformState();
    super.initState();
  }

  loadProducts() async {
    print("loadProducts() => Executed!");
    try {
      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(_productLists);
      if (response.notFoundIDs.isNotEmpty) {
        // Handle the error.
      }
      List<ProductDetails> products = response.productDetails;
      print("products $products");
      products.forEach((ProductDetails productDetails) {
        print(productDetails.id);
        _items.add(productDetails);
      });
      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  getPurchase() {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

  @override
  void dispose() async {
    super.dispose();
    pageController.dispose();
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  _getPlans() async {
    try {
      await _planController.getPlan();
      _loading = false;
      setState(() {});
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err);
    }
  }

  Future<void> initPlatformState() async {
    try {
      if (!mounted) return;

      final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
        // purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
        //   if (purchaseDetails.pendingCompletePurchase) {
        //     await InAppPurchase.instance.completePurchase(purchaseDetails);
        //     User user = _userController.user.value;
        //
        //     if (user.payment == null) {
        //       await _paymentController.addPayment(purchaseDetails.productID);
        //       await _userController.getUser();
        //       Get.back();
        //     }
        //   }
        // });
      }, onDone: () {
        _subscription.cancel();
      }, onError: (err) {
        print(err);
        showError(err);
      });
      await _getProducts();
    } catch (err) {
      //  print(err);
      //  showError(err);
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("Status is pending");
        //_showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          showError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          print("Status is purchased");
          // bool valid = await _verifyPurchase(purchaseDetails);
          // if (valid) {
          //   _deliverProduct(purchaseDetails);
          // } else {
          //   _handleInvalidPurchase(purchaseDetails);
          // }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future _getProducts() async {
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_productLists.toSet());
    if (response.notFoundIDs.isNotEmpty) {
      throw "No products found";
    }
    //   List<ProductDetails> products = response.productDetails;
    //   _items = products;
  }

  //
  Future _purchasePlan(ProductDetails item) async {
    try {
      print(item);
      // final ProductDetails productDetails = item;
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: item);
      print(purchaseParam);
      var result = await InAppPurchase.instance
          .buyNonConsumable(purchaseParam: purchaseParam);
      print("result $result");
      // var paymentWrapper = SKPaymentQueueWrapper();
      // var transactions = await paymentWrapper.transactions();
      // transactions.forEach((transaction) async {
      //   await paymentWrapper.finishTransaction(transaction);
      // });
      // if (productDetails.id != 'rons.ronary.com') {
      //   await InAppPurchase.instance.buyConsumable(
      //       purchaseParam: purchaseParam, autoConsume: Platform.isIOS);
      // } else {
      //   await InAppPurchase.instance
      //       .buyNonConsumable(purchaseParam: purchaseParam);
      // }
      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  // Future _selectPlan(Plan plan) async {
  //   try {
  //     _loading = true;
  //     setState(() {});
  //     await _paymentController.selectPlan(plan);
  //     _loading = false;
  //     setState(() {});
  //     Get.offAll(
  //       () => Start(),
  //       transition: Transition.noTransition,
  //     );
  //   } catch (err) {
  //     _loading = false;
  //     setState(() {});
  //     showError(err);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    _heightMedia = Get.height;
    return LoadingPage(
        //_items == null || _items.length == 0,
        _loading, GetBuilder<PlanController>(builder: (_controller) {
      return Container(
        height: Get.height,
        child: Column(
          children: [
            TitlePage(
              title: widget.changePlan != null && widget.changePlan
                  ? "Change Plan"
                  : "Subscription Plan",
              description: "Select plan for your business needs",
              needNav: true,
            ),
            SizedBox(height: _heightMedia > 700 ? 30 : 10),
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
                child: Padding(
                    padding: EdgeInsets.all(1),
                    child: Row(
                      children: [
                        ..._items.asMap().entries.map((item) {
                          int index = item.key;
                          return Expanded(
                            child: InkWell(
                              onTap: () {
                                pageController.animateToPage(
                                  index,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOut,
                                );
                                setState(() {});
                              },
                              child: Container(
                                height: reSize(30),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: _indexPage == index
                                        ? Color(0xFFFFC600)
                                        : Colors.transparent),
                                child: Center(
                                  child: Text(
                                    item.value.title,
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    )),
              ),
            ),
            SizedBox(height: _heightMedia > 700 ? 70 : 30),
            Expanded(
              child: Container(
                height: reSize(366),
                child: PageView(
                  controller: pageController,
                  clipBehavior: Clip.none,
                  onPageChanged: (int page) {
                    _indexPage = page;
                    setState(() {});
                  },
                  children: <Widget>[
                    ..._controller.plans.asMap().entries.map((item) {
                      int index = item.key;
                      return PlanBlock(
                        indexPage: _indexPage,
                        indexBlock: index,
                        product: null,
                      );
                    })
                  ],
                ),
              ),
            ),
            SizedBox(height: _heightMedia > 700 ? 70 : 30),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(text: '*\$25 for each additional notarization'),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ButtonPrimary(
                text: 'Subscribe',
                callback: () => _purchasePlan(_items[_indexPage]),
                //  callback: () => _selectPlan(_planController.plans[_indexPage]),
              ),
            ),
            SizedBox(height: Get.height < 670 ? 20 : reSize(40)),
          ],
        ),
      );
    }));
  }

// GooglePlayPurchaseDetails _getOldSubscription(
//     ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
//   GooglePlayPurchaseDetails oldSubscription;
//   // if (productDetails.id == _kSilverSubscriptionId &&
//   //     purchases[_kGoldSubscriptionId] != null) {
//   //   oldSubscription =
//   //       purchases[_kGoldSubscriptionId] as GooglePlayPurchaseDetails;
//   // } else if (productDetails.id == _kGoldSubscriptionId &&
//   //     purchases[_kSilverSubscriptionId] != null) {
//   //   oldSubscription =
//   //       purchases[_kSilverSubscriptionId] as GooglePlayPurchaseDetails;
//   // }
//   return oldSubscription;
// }
}

// /// Example implementation of the
// /// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
// ///
// /// The payment queue delegate can be implementated to provide information
// /// needed to complete transactions.
// class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
//   @override
//   bool shouldContinueTransaction(
//       SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
//     return true;
//   }
//
//   @override
//   bool shouldShowPriceConsent() {
//     return false;
//   }
// }
