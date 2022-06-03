// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
// import 'package:flutter_svg/svg.dart';
//
// import '../methods/resize_formatting.dart';
// import '../utils/navigate.dart';
// import 'button_primary.dart';
// import 'loading.dart';
//
// const List<String> _productId = ["extra.ronary.com"];
//
// class BuyExtra extends StatefulWidget {
//   @override
//   _BuyExtraState createState() => _BuyExtraState();
// }
//
// class _BuyExtraState extends State<BuyExtra> {
//   StreamSubscription _purchaseUpdatedSubscription;
//   StreamSubscription _purchaseErrorSubscription;
//   StreamSubscription _connectionSubscription;
//   bool _loading;
//   int _extraNotarization;
//   IAPItem _extra;
//   FlutterInappPurchase _appPurchase = FlutterInappPurchase.instance;
//
//   @override
//   initState() {
//     _loading = false;
//     _extraNotarization = 1;
//     _appPurchase.initialize();
//     _initPlatform();
//     super.initState();
//   }
//
//   Future<void> _listenPurchase(productItem) async {
//     try {
//       print(productItem);
//     } catch (err) {}
//   }
//
//   _initPlatform() async {
//     try {
//       _purchaseUpdatedSubscription =
//           FlutterInappPurchase.purchaseUpdated.listen(_listenPurchase);
//       _connectionSubscription =
//           FlutterInappPurchase.connectionUpdated.listen((connected) {
//         print('connected: $connected');
//       });
//       _purchaseErrorSubscription =
//           FlutterInappPurchase.purchaseError.listen((purchaseError) {
//         print('purchase-error: $purchaseError}');
//         // showError(purchaseError.message, context);
//         _loading = false;
//         setState(() {});
//       });
//       await _getProduct();
//     } catch (err) {
//       print(err);
//     }
//   }
//
//   Future _getProduct() async {
//     print("_getProduct() => Executed!");
//     List<IAPItem> items = await _appPurchase.getProducts(_productId);
//     for (var item in items) {
//       print(item.productId);
//     }
//     if (items.isNotEmpty) {
//       _extra = items[0];
//     }
//
//     setState(() {
//       _loading = false;
//     });
//   }
//
//   @override
//   dispose() async {
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
//   void _minusExtra() {
//     if (_extraNotarization > 1) {
//       _extraNotarization -= 1;
//       setState(() {});
//     }
//   }
//
//   void _plusExtra() {
//     if (_extraNotarization < 9) {
//       _extraNotarization += 1;
//       setState(() {});
//     }
//   }
//
//   Future<void> _buyConsumable() async {
//     try {
//       if (Platform.isAndroid) {
//         await _appPurchase.requestPurchase(
//           _extra.productId,
//           obfuscatedAccountId: "",
//           purchaseTokenAndroid: "",
//           obfuscatedProfileIdAndroid: "",
//         );
//       } else {
//         await _appPurchase.requestPurchaseWithQuantityIOS(
//           _extra.productId,
//           _extraNotarization,
//         );
//       }
//     } catch (err) {}
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: StateM(context).height() / 2,
//         child: _loading ? Center(child: Loading()) : Center(child: Text("SOON"))
//
//         // Column(
//         //         crossAxisAlignment: CrossAxisAlignment.start,
//         //         mainAxisAlignment: MainAxisAlignment.start,
//         //         children: [
//         //           SizedBox(height: reSize(context, 30)),
//         //           Padding(
//         //             padding:
//         //                 EdgeInsets.symmetric(horizontal: reSize(context, 20)),
//         //             child: Column(
//         //               crossAxisAlignment: CrossAxisAlignment.start,
//         //               children: [
//         //                 Text(
//         //                   "Buy RON Sessions",
//         //                   style: TextStyle(
//         //                     color: Color(0xFF161617),
//         //                     fontSize: 24,
//         //                     fontWeight: FontWeight.w500,
//         //                   ),
//         //                 ),
//         //                 SizedBox(height: reSize(context, 5)),
//         //                 Text(
//         //                   "Select number of RON credits",
//         //                   style: TextStyle(
//         //                     color: Color(0xFFADAEAF),
//         //                     fontSize: 14,
//         //                     fontWeight: FontWeight.w400,
//         //                   ),
//         //                 ),
//         //               ],
//         //             ),
//         //           ),
//         //           SizedBox(height: reSize(context, 30)),
//         //           Expanded(
//         //             child: Padding(
//         //                 padding: const EdgeInsets.symmetric(horizontal: 20),
//         //                 child: Container(
//         //                   child: Row(
//         //                     mainAxisAlignment: MainAxisAlignment.center,
//         //                     children: [
//         //                       ClipRRect(
//         //                         borderRadius: BorderRadius.circular(28),
//         //                         child: Container(
//         //                           width: reSize(context, 32),
//         //                           height: reSize(context, 32),
//         //                           child: TextButton(
//         //                             onPressed: _extraNotarization <= 1
//         //                                 ? null
//         //                                 : _minusExtra,
//         //                             //  paymentProvider.minusNotarization(),
//         //                             style: ButtonStyle(
//         //                               backgroundColor: MaterialStateProperty.all(
//         //                                   Color(0xFFE1E1E1)),
//         //                               overlayColor: MaterialStateProperty.all(
//         //                                 Theme.of(context)
//         //                                     .colorScheme
//         //                                     .secondary
//         //                                     .withOpacity(0.2),
//         //                               ),
//         //                               padding: MaterialStateProperty.all(
//         //                                   EdgeInsets.zero),
//         //                             ),
//         //                             child: Container(
//         //                               width: reSize(context, 28),
//         //                               height: reSize(context, 28),
//         //                               child: Center(
//         //                                 child: SvgPicture.asset(
//         //                                     "assets/images/80.svg"),
//         //                               ),
//         //                             ),
//         //                           ),
//         //                         ),
//         //                       ),
//         //                       SizedBox(width: reSize(context, 40)),
//         //                       Container(
//         //                         height: reSize(context, 60),
//         //                         decoration: BoxDecoration(
//         //                             border: Border(
//         //                           bottom: BorderSide(
//         //                               width: 1.0, color: Color(0xFFE1E1E1)),
//         //                         )),
//         //                         child: Center(
//         //                           child: Text(
//         //                             _extraNotarization.toString(),
//         //                             style: TextStyle(
//         //                               fontSize: 48,
//         //                               color:
//         //                                   Theme.of(context).colorScheme.secondary,
//         //                             ),
//         //                           ),
//         //                         ),
//         //                       ),
//         //                       SizedBox(width: reSize(context, 40)),
//         //                       ClipRRect(
//         //                         borderRadius: BorderRadius.circular(28),
//         //                         child: Container(
//         //                           width: reSize(context, 32),
//         //                           height: reSize(context, 32),
//         //                           child: TextButton(
//         //                             onPressed: _plusExtra,
//         //                             style: ButtonStyle(
//         //                               backgroundColor: MaterialStateProperty.all(
//         //                                   Color(0xFFE1E1E1)),
//         //                               overlayColor: MaterialStateProperty.all(
//         //                                 Theme.of(context)
//         //                                     .colorScheme
//         //                                     .secondary
//         //                                     .withOpacity(0.2),
//         //                               ),
//         //                               padding: MaterialStateProperty.all(
//         //                                   EdgeInsets.zero),
//         //                             ),
//         //                             child: Container(
//         //                               width: reSize(context, 28),
//         //                               height: reSize(context, 28),
//         //                               child: Center(
//         //                                 child: SvgPicture.asset(
//         //                                     "assets/images/79.svg"),
//         //                               ),
//         //                             ),
//         //                           ),
//         //                         ),
//         //                       ),
//         //                     ],
//         //                   ),
//         //                 )),
//         //           ),
//         //           SizedBox(height: reSize(context, 15)),
//         //           Padding(
//         //             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         //             child: Container(
//         //                 width: StateM(context).width() - 40,
//         //                 child: Text(
//         //                   "Maximum 9 RON's",
//         //                   style: TextStyle(
//         //                     color: Color(0xFF494949),
//         //                     fontSize: 14,
//         //                   ),
//         //                   textAlign: TextAlign.center,
//         //                 )),
//         //           ),
//         //           SizedBox(height: reSize(context, 5)),
//         //           Padding(
//         //             padding: const EdgeInsets.symmetric(horizontal: 20),
//         //             child: ButtonPrimary(
//         //               text: "Buy for \$${_extraNotarization * 25}",
//         //               callback: _buyConsumable,
//         //             ),
//         //           ),
//         //           SizedBox(
//         //               height: StateM(context).height() < 670
//         //                   ? 20
//         //                   : reSize(context, 40)),
//         //         ],
//         //       ),
//         );
//   }
// }
