import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/widgets/loading_page.dart';
// import 'package:in_app_purchase_android/billing_client_wrappers.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
//import 'package:notary/widgets/payment_success.dart';
import 'package:provider/provider.dart';
import '../controllers/plan.dart';
import '../methods/resize_formatting.dart';
import '../utils/navigate.dart';
import '../widgets/title_page.dart';

// const Set<String> _productIds = <String>{
//   'basic.ronary.com',
//   'business.ronary.com',
//   'pro.ronary.com',
// };

class PurchaseRon extends StatefulWidget {
  @override
  _PurchaseRonState createState() => _PurchaseRonState();
}

class _PurchaseRonState extends State<PurchaseRon> {
  PlanController _planController;
  int _indexPage;
  PageController pageController;

  // InAppPurchase _inAppPurchase = InAppPurchase.instance;
  // StreamSubscription<List<PurchaseDetails>> _subscription;
  // List<ProductDetails> _products = [];
  // List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  // PurchaseDetails _oldPurchaseDetails;
  bool _loading;

  @override
  void initState() {
    _loading = true;
    _indexPage = 1;
    pageController =
        PageController(viewportFraction: 0.8, initialPage: _indexPage);
    _planController = Provider.of<PlanController>(context, listen: false);
    _initPlatform();
    super.initState();
  }

  _initPlatform() async {
    await _planController.getPlan();
    await _loadProducts();
    // await _finishAllTransactions();
    // final Stream purchaseUpdated = _inAppPurchase.purchaseStream;
    // _subscription = purchaseUpdated.listen((purchaseDetailsList) {
    //   _listenToPurchaseUpdated(purchaseDetailsList);
    // }, onDone: () {
    //   _subscription.cancel();
    // }, onError: (error) {
    //   print("Error subscription $error");
    //   // handle error here.
    // });
  }

  // _finishAllTransactions() async {
  //   // var transactions = await SKPaymentQueueWrapper().transactions();
  //   // transactions.forEach((skPaymentTransactionWrapper) {
  //   //   SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
  //   // });
  // }

  _loadProducts() async {
    try {
      if (Platform.isAndroid) {
        // InAppPurchaseAndroidPlatformAddition androidAddition = _inAppPurchase
        //     .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        //
        // QueryPurchaseDetailsResponse response =
        //     await androidAddition.queryPastPurchases();
        //
        // print("response $response");
        // print(response.pastPurchases.length);
        // _purchases = response.pastPurchases;
        // if (_purchases.length > 0) {
        //   _oldPurchaseDetails = _purchases.last;
        // }
        // setState(() {});
      }

      // final ProductDetailsResponse response =
      //     await InAppPurchase.instance.queryProductDetails(_productIds);
      //
      // if (response.notFoundIDs.isNotEmpty) {
      //   print(response.error);
      //   throw "Something was wrong";
      // }
      //
      // _products = response.productDetails;
      // _loading = false;
      // setState(() {});
    } catch (err) {
      _loading = false;
      setState(() {});
      showError(err, context);
    }
  }

  // _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
  //   purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
  //     try {
  //       if (purchaseDetails.status == PurchaseStatus.restored) {
  //         await _inAppPurchase.completePurchase(purchaseDetails);
  //         return;
  //       }
  //       if (purchaseDetails.status == PurchaseStatus.pending) {
  //         _loading = true;
  //         setState(() {});
  //       } else {
  //         if (purchaseDetails.status == PurchaseStatus.error) {
  //           print("Purchase is error!");
  //           _loading = false;
  //           setState(() {});
  //         } else if (purchaseDetails.status == PurchaseStatus.canceled) {
  //           print("canceled ${purchaseDetails.productID}");
  //           // bool valid = await _verifyPurchase(purchaseDetails);
  //           // if (valid) {
  //           //   _deliverProduct(purchaseDetails);
  //           // } else {
  //           //   _handleInvalidPurchase(purchaseDetails);
  //           // }
  //           _loading = false;
  //           setState(() {});
  //         } else if (purchaseDetails.status == PurchaseStatus.purchased) {
  //           bool valid = false;
  //           print(purchaseDetails.productID);
  //           valid = await _paymentController.verifyPayment(
  //             purchaseDetails.verificationData.serverVerificationData,
  //             purchaseDetails.productID,
  //           );
  //           print("valid $valid");
  //           if (valid) {
  //             _oldPurchaseDetails = purchaseDetails;
  //             StateM(context).navOff(PaymentSuccess());
  //             _loading = false;
  //             setState(() {});
  //           } else {
  //             _loading = false;
  //             setState(() {});
  //             // showError("Something was wrong!", context);
  //           }
  //         }
  //         // else if (purchaseDetails.status == PurchaseStatus.restored) {
  //         //   print("Restore purchase!");
  //         //   await _paymentController.verifyPayment(
  //         //       purchaseDetails.verificationData.serverVerificationData,
  //         //       purchaseDetails.productID,
  //         //       'payment/reset');
  //         // }
  //         if (purchaseDetails.pendingCompletePurchase) {
  //           await _inAppPurchase.completePurchase(purchaseDetails);
  //         }
  //       }
  //     } catch (err) {
  //       _loading = false;
  //       setState(() {});
  //       showError(err, context);
  //     }
  //   });
  // }

  // _buyProduct() async {
  //   print("_buyProduct() => Executed!");
  //   ProductDetails productDetails = _products[_indexPage];
  //   try {
  //     await _finishAllTransactions();
  //     if (Platform.isAndroid) {
  //       if (_oldPurchaseDetails != null) {
  //         print("oldPurchaseDetails ${_oldPurchaseDetails.transactionDate}");
  //         PurchaseParam purchaseParam = GooglePlayPurchaseParam(
  //           productDetails: productDetails,
  //           applicationUserName: _userController.user.email,
  //           changeSubscriptionParam: ChangeSubscriptionParam(
  //             oldPurchaseDetails: _oldPurchaseDetails,
  //             prorationMode: ProrationMode.immediateWithTimeProration,
  //           ),
  //         );
  //         _inAppPurchase.buyNonConsumable(
  //           purchaseParam: purchaseParam,
  //         );
  //       } else {
  //         PurchaseParam purchaseParam = GooglePlayPurchaseParam(
  //           productDetails: productDetails,
  //           applicationUserName: _userController.user.email,
  //         );
  //         _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  //       }
  //     } else {
  //       PurchaseParam purchaseParam = PurchaseParam(
  //         productDetails: productDetails,
  //         applicationUserName: _userController.user.email,
  //       );
  //       _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  //     }
  //   } catch (err) {
  //     print("_buyProduct => Error $err");
  //     throw err;
  //   }
  // }

  // String _getTitle(String identifier) {
  //   print(_planController.plans);
  //   Plan _plan = _planController.plans
  //       .firstWhere((element) => element.productId == identifier);
  //   return _plan.title;
  // }

  @override
  void dispose() {
    // _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
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
                        // children: [
                        //   ..._products.asMap().entries.map((package) {
                        //     int index = package.key;
                        //     return Expanded(
                        //       child: InkWell(
                        //         onTap: () {
                        //           pageController.animateToPage(
                        //             index,
                        //             duration: const Duration(seconds: 1),
                        //             curve: Curves.easeInOut,
                        //           );
                        //           _indexPage = index;
                        //           setState(() {});
                        //         },
                        //         child: Container(
                        //           height: reSize(context, 30),
                        //           decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.circular(2),
                        //               color: _indexPage == index
                        //                   ? Color(0xFFFFC600)
                        //                   : Colors.transparent),
                        //           child: Center(
                        //             child: Text(
                        //               _getTitle(package.value.id),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   }),
                        // ],
                        ),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(4),
            //       border: Border.all(
            //         width: 1,
            //         color: Color(0xFF000000).withOpacity(0.14),
            //       ),
            //     ),
            //     child: Container(
            //       child: Padding(
            //         padding: EdgeInsets.all(1),
            //         child: PageView(
            //           controller: pageController,
            //           clipBehavior: Clip.none,
            //           onPageChanged: (int page) {
            //             _indexPage = page;
            //             setState(() {});
            //           },
            //           children: [
            //             ..._items.asMap().entries.map((package) {
            //               int index = package.key;
            //               return Expanded(
            //                 child: InkWell(
            //                   onTap: () {
            //                     pageController.animateToPage(
            //                       index,
            //                       duration: const Duration(seconds: 1),
            //                       curve: Curves.easeInOut,
            //                     );
            //                     _indexPage = index;
            //                     setState(() {});
            //                   },
            //                   child: Container(
            //                     height: reSize(context, 30),
            //                     decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(2),
            //                         color: _indexPage == index
            //                             ? Color(0xFFFFC600)
            //                             : Colors.transparent),
            //                     child: Center(
            //                       child: Text(
            //                         _getTitle(package.value.title),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               );
            //             }),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
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
                //       // product: _products[index],
                //       plan: _planController.plans.length > 0
                //           ? _planController.plans.firstWhere((element) =>
                //               element.productId == _products[index].id)
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
            // ..._items.map(
            //   (item) => PlanBlock(
            //     indexPage: _indexPage,
            //     indexBlock: _indexPage,
            //     product: _items[_indexPage],
            //     plan: _planController.plans.length > 0
            //         ? _planController.plans.firstWhere((element) =>
            //             element.productId ==
            //             _items[_indexPage].productId)
            //         : null,
            //   ),
            // ),
            // Expanded(
            //     flex: 2,
            //     child: SingleChildScrollView(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           if (_purchases.length > 0)
            //             ..._purchases.map((item) => Column(
            //                   children: [
            //                     Text(item.productId),
            //                     Text("${item.transactionDate}"),
            //                     Text("${item.transactionId}"),
            //                   ],
            //                 )),
            //         ],
            //       ),
            //     ))
            SizedBox(height: reSize(context, 30)),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //   child: ButtonPrimary(
            //     text: 'Subscribe',
            //     // callback: _products.length == 0 ||
            //     //         _userController.payment != null &&
            //     //             _userController.payment.plan.productId ==
            //     //                 _products[_indexPage].identifier
            //     //     ? null
            //     //     : () => _buyProduct(_products[_indexPage]),
            //     callback: _products.length > 0 &&
            //             _oldPurchaseDetails != null &&
            //             _oldPurchaseDetails.productID ==
            //                 _products[_indexPage].id
            //         ? null
            //         : () => _buyProduct(),
            //   ),
            // ),
            SizedBox(
                height:
                    StateM(context).height() < 670 ? 20 : reSize(context, 40)),
          ],
        ),
      ),
    );
  }
}
