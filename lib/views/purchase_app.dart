// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:notary/controllers/user.dart';
// import 'package:notary/methods/show_error.dart';
// import 'package:notary/utils/navigate.dart';
// import 'package:notary/views/start.dart';
// import 'package:notary/widgets/loading_page.dart';
// import 'package:notary/widgets/title_page.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
//
// import '../controllers/payment.dart';
// import '../controllers/plan.dart';
// import '../methods/resize_formatting.dart';
// import '../models/plan.dart';
// import '../widgets/button_primary.dart';
// import '../widgets/plan_block.dart';
//
// const List<String> _productIds = <String>[
//   'basic.ronary.com',
//   'business.ronary.com',
//   'pro.ronary.com'
// ];
//
// class PurchaseApp extends StatefulWidget {
//   const PurchaseApp({Key key}) : super(key: key);
//
//   @override
//   _PurchaseAppState createState() => _PurchaseAppState();
// }
//
// class _PurchaseAppState extends State<PurchaseApp> {
//   StreamSubscription _purchaseUpdatedSubscription;
//   StreamSubscription _purchaseErrorSubscription;
//   StreamSubscription _connectionSubscription;
//   FlutterInappPurchase _appPurchase = FlutterInappPurchase.instance;
//
//   List<IAPItem> _items = [];
//   List<PurchasedItem> _purchases = [];
//   UserController _userController;
//   bool _loading;
//   int _indexPage;
//   PageController pageController;
//
//   PaymentController _paymentController;
//   PlanController _planController;
//
//   @override
//   void initState() {
//     _loading = true;
//     _userController = Provider.of<UserController>(context, listen: false);
//     _indexPage = 1;
//
//     pageController =
//         PageController(viewportFraction: 0.8, initialPage: _indexPage);
//     _paymentController = Provider.of<PaymentController>(context, listen: false);
//     _planController = Provider.of<PlanController>(context, listen: false);
//     _initPlatformState();
//     super.initState();
//   }
//
//   Future<void> _initPlatformState() async {
//     await _planController.getPlan();
//     await _appPurchase.initialize();
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     // refresh items for android
//     // try {
//     //   String msg = await _appPurchase.consumeAll();
//     //   print('consumeAllItems: $msg');
//     // } catch (err) {
//     //   print('consumeAllItems error: $err');
//     // }
//
//     _connectionSubscription =
//         FlutterInappPurchase.connectionUpdated.listen((connected) {
//       print('connected: $connected');
//     });
//
//     Future<void> _listenPurchase(productItem) async {
//       try {
//         if (Platform.isAndroid) {
//           print("productItem $productItem}");
//
//           PurchaseState purchaseState = productItem.purchaseStateAndroid;
//           if (purchaseState == PurchaseState.pending) {
//             _loading = false;
//             setState(() {});
//             return;
//           }
//           bool valid = await _paymentController.verifyPlayPayment(
//               productItem.purchaseToken, productItem.productId);
//
//           if (valid) {
//             await _appPurchase.finishTransaction(productItem);
//             await _appPurchase
//                 .acknowledgePurchaseAndroid(productItem.purchaseToken);
//             if (purchaseState == PurchaseState.purchased) {
//               StateM(context).navOff(Start());
//               return;
//             }
//             _loading = false;
//             setState(() {});
//           } else {
//             _loading = false;
//             setState(() {});
//             showError("Something was wrong!", context);
//           }
//         } else {
//           TransactionState transactionState = productItem.transactionStateIOS;
//           if (transactionState == TransactionState.restored) {
//             _loading = false;
//             setState(() {});
//             return;
//           }
//           bool valid = await _paymentController
//               .verifyPayment(productItem.transactionReceipt);
//           if (valid) {
//             await _appPurchase.finishTransactionIOS(productItem.purchaseToken);
//             await _userController.getUser();
//             _loading = false;
//             setState(() {});
//             if (transactionState == TransactionState.purchased) {
//               StateM(context).navOff(Start());
//               return;
//             }
//           } else {
//             _loading = false;
//             setState(() {});
//             showError("Something was wrong!", context);
//           }
//         }
//       } catch (err) {
//         _loading = false;
//         setState(() {});
//         print(err);
//       }
//       if (_purchases.isEmpty) {
//         _purchases.add(productItem);
//       } else {
//         _purchases.insert(0, productItem);
//       }
//     }
//
//     _purchaseUpdatedSubscription =
//         FlutterInappPurchase.purchaseUpdated.listen(_listenPurchase);
//
//     _purchaseErrorSubscription =
//         FlutterInappPurchase.purchaseError.listen((purchaseError) {
//       print('purchase-error: $purchaseError}');
//       // showError(purchaseError.message, context);
//       _loading = false;
//       setState(() {});
//     });
//     await _getProduct();
//     await _getPurchases();
//   }
//
//   Future _getProduct() async {
//     print("_getProduct() => Executed!");
//     List<IAPItem> items = Platform.isAndroid
//         ? await _appPurchase.getSubscriptions(_productIds)
//         : await _appPurchase.getProducts(_productIds);
//     for (var item in items) {
//       this._items.add(item);
//     }
//
//     setState(() {
//       this._items = items;
//       _loading = false;
//     });
//   }
//
//   Future _getPurchases() async {
//     print("_getPurchases() => Executed!");
//     List<PurchasedItem> items = await _appPurchase.getAvailablePurchases();
//     items.sort((a, b) {
//       var aDate = a.transactionDate;
//       var bDate = b.transactionDate;
//       return -aDate.compareTo(bDate);
//     });
//     for (var item in items) {
//       _purchases.add(item);
//     }
//     setState(() {});
//     print(_purchases.length);
//   }
//
//   void _requestPurchase() async {
//     _loading = true;
//     setState(() {});
//
//     try {
//       IAPItem item = _items[_indexPage];
//       PurchasedItem _oldPurchase;
//       if (_purchases.length > 0) {
//         _oldPurchase = _purchases.first;
//       }
//       if (_oldPurchase != null) {
//         print("_userController.user.id ${_userController.user.id}");
//         print("_userController.user.email ${_userController.user.email}");
//         await _appPurchase.requestSubscription(
//           item.productId,
//           oldSkuAndroid: _oldPurchase.transactionId,
//           prorationModeAndroid: 1,
//           obfuscatedAccountIdAndroid: _userController.user.id,
//           obfuscatedProfileIdAndroid: _userController.user.email,
//           purchaseTokenAndroid: _oldPurchase.purchaseToken,
//         );
//       } else {
//         await _appPurchase.requestSubscription(
//           item.productId,
//         );
//       }
//     } catch (err) {
//       _loading = false;
//       setState(() {});
//       showError(err, context);
//     }
//   }
//
//   _getPurchaseHistory() async {
//     print("_getPurchaseHistory() => Executed!");
//     try {
//       List<PurchasedItem> _purchasedItems =
//           await _appPurchase.getPurchaseHistory();
//     } catch (err) {
//       print(err);
//     }
//   }
//
//   String _getTitle(String identifier) {
//     Plan _plan = _planController.plans
//         .firstWhere((element) => element.productId == identifier);
//     return _plan.title;
//   }
//
//   @override
//   void dispose() async {
//     super.dispose();
//     if (_connectionSubscription != null) {
//       _connectionSubscription.cancel();
//       _connectionSubscription = null;
//     }
//     if (_purchaseUpdatedSubscription != null) {
//       _purchaseUpdatedSubscription.cancel();
//       _purchaseUpdatedSubscription = null;
//     }
//     if (_purchaseErrorSubscription != null) {
//       _purchaseErrorSubscription.cancel();
//       _purchaseErrorSubscription = null;
//     }
//     await _appPurchase.finalize();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LoadingPage(
//           _loading,
//           Container(
//             width: StateM(context).width(),
//             height: StateM(context).height(),
//             child: Column(
//               children: [
//                 TitlePage(
//                   title: "Subscription Plan",
//                   description: "Select plan for your business needs",
//                   needNav: true,
//                 ),
//                 SizedBox(height: StateM(context).height() > 700 ? 30 : 10),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(4),
//                       border: Border.all(
//                         width: 1,
//                         color: Color(0xFF000000).withOpacity(0.14),
//                       ),
//                     ),
//                     child: Container(
//                       child: Padding(
//                         padding: EdgeInsets.all(1),
//                         child: Row(
//                           children: [
//                             ..._items.asMap().entries.map((package) {
//                               int index = package.key;
//                               return Expanded(
//                                 child: InkWell(
//                                   onTap: () {
//                                     pageController.animateToPage(
//                                       index,
//                                       duration: const Duration(seconds: 1),
//                                       curve: Curves.easeInOut,
//                                     );
//                                     _indexPage = index;
//                                     setState(() {});
//                                   },
//                                   child: Container(
//                                     height: reSize(context, 30),
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(2),
//                                         color: _indexPage == index
//                                             ? Color(0xFFFFC600)
//                                             : Colors.transparent),
//                                     child: Center(
//                                       child: Text(
//                                         _getTitle(package.value.productId),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 //   child: Container(
//                 //     decoration: BoxDecoration(
//                 //       borderRadius: BorderRadius.circular(4),
//                 //       border: Border.all(
//                 //         width: 1,
//                 //         color: Color(0xFF000000).withOpacity(0.14),
//                 //       ),
//                 //     ),
//                 //     child: Container(
//                 //       child: Padding(
//                 //         padding: EdgeInsets.all(1),
//                 //         child: PageView(
//                 //           controller: pageController,
//                 //           clipBehavior: Clip.none,
//                 //           onPageChanged: (int page) {
//                 //             _indexPage = page;
//                 //             setState(() {});
//                 //           },
//                 //           children: [
//                 //             ..._items.asMap().entries.map((package) {
//                 //               int index = package.key;
//                 //               return Expanded(
//                 //                 child: InkWell(
//                 //                   onTap: () {
//                 //                     pageController.animateToPage(
//                 //                       index,
//                 //                       duration: const Duration(seconds: 1),
//                 //                       curve: Curves.easeInOut,
//                 //                     );
//                 //                     _indexPage = index;
//                 //                     setState(() {});
//                 //                   },
//                 //                   child: Container(
//                 //                     height: reSize(context, 30),
//                 //                     decoration: BoxDecoration(
//                 //                         borderRadius: BorderRadius.circular(2),
//                 //                         color: _indexPage == index
//                 //                             ? Color(0xFFFFC600)
//                 //                             : Colors.transparent),
//                 //                     child: Center(
//                 //                       child: Text(
//                 //                         _getTitle(package.value.title),
//                 //                       ),
//                 //                     ),
//                 //                   ),
//                 //                 ),
//                 //               );
//                 //             }),
//                 //           ],
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 SizedBox(height: reSize(context, 30)),
//                 Expanded(
//                   child: PageView(
//                     controller: pageController,
//                     clipBehavior: Clip.none,
//                     onPageChanged: (int page) {
//                       _indexPage = page;
//                       setState(() {});
//                     },
//                     children: <Widget>[
//                       ..._items.asMap().entries.map((package) {
//                         int index = package.key;
//                         return PlanBlock(
//                           indexPage: _indexPage,
//                           indexBlock: index,
//                           product: _items[index],
//                           plan: _planController.plans.length > 0
//                               ? _planController.plans.firstWhere((element) =>
//                                   element.productId ==
//                                   _items[index].productId)
//                               : null,
//                         );
//                         // return Container(
//                         //   child: Padding(
//                         //     padding: const EdgeInsets.symmetric(horizontal: 20),
//                         //     child: Column(
//                         //       children: [
//                         //         Text(product.value.title),
//                         //         Text(product.value.description),
//                         //         Text(product.value.priceString),
//                         //         SizedBox(
//                         //           height: 10,
//                         //         ),
//                         //         TextButton(
//                         //             //  onPressed: () => _buyProduct(product),
//                         //             onPressed: _userController.payment != null &&
//                         //                     _userController
//                         //                             .payment.plan.productId ==
//                         //                         product.value.identifier
//                         //                 ? null
//                         //                 : () => _buyProduct(product.value),
//                         //             child: Text("Buy")),
//                         //         Container(
//                         //           color: Color(0xFFCCCCCC),
//                         //           height: 1,
//                         //         ),
//                         //         SizedBox(
//                         //           height: 10,
//                         //         ),
//                         //       ],
//                         //     ),
//                         //   ),
//                         // );
//                       }),
//                     ],
//                   ),
//                 ),
//                 // ..._items.map(
//                 //   (item) => PlanBlock(
//                 //     indexPage: _indexPage,
//                 //     indexBlock: _indexPage,
//                 //     product: _items[_indexPage],
//                 //     plan: _planController.plans.length > 0
//                 //         ? _planController.plans.firstWhere((element) =>
//                 //             element.productId ==
//                 //             _items[_indexPage].productId)
//                 //         : null,
//                 //   ),
//                 // ),
//                 // Expanded(
//                 //     flex: 2,
//                 //     child: SingleChildScrollView(
//                 //       child: Column(
//                 //         crossAxisAlignment: CrossAxisAlignment.center,
//                 //         mainAxisAlignment: MainAxisAlignment.center,
//                 //         children: [
//                 //           if (_purchases.length > 0)
//                 //             ..._purchases.map((item) => Column(
//                 //                   children: [
//                 //                     Text(item.productId),
//                 //                     Text("${item.transactionDate}"),
//                 //                     Text("${item.transactionId}"),
//                 //                   ],
//                 //                 )),
//                 //         ],
//                 //       ),
//                 //     ))
//                 SizedBox(height: reSize(context, 30)),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child: ButtonPrimary(
//                     text: 'Subscribe',
//                     // callback: _products.length == 0 ||
//                     //         _userController.payment != null &&
//                     //             _userController.payment.plan.productId ==
//                     //                 _products[_indexPage].identifier
//                     //     ? null
//                     //     : () => _buyProduct(_products[_indexPage]),
//                     callback: () => _requestPurchase(),
//                   ),
//                 ),
//                 SizedBox(
//                     height: StateM(context).height() < 670
//                         ? 20
//                         : reSize(context, 40)),
//               ],
//             ),
//           )),
//     );
//   }
// }
