// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:notary/controllers/plan.dart';
// import 'package:notary/controllers/user.dart';
// import 'package:notary/methods/resize_formatting.dart';
// import 'package:notary/utils/navigate.dart';
// import 'package:notary/views/start.dart';
// import 'package:notary/widgets/button_primary.dart';
// import 'package:notary/widgets/button_primary_outline.dart';
// import 'package:notary/widgets/loading_page.dart';
// import 'package:notary/widgets/network_connection.dart';
// import 'package:notary/widgets/payment_success.dart';
// import 'package:notary/widgets/plan_block.dart';
// import 'package:notary/widgets/title_page.dart';
// import 'package:provider/provider.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
//
// import '../models/plan.dart';
//
// class PurchaseCat extends StatefulWidget {
//   const PurchaseCat({Key key}) : super(key: key);
//
//   @override
//   _PurchaseCatState createState() => _PurchaseCatState();
// }
//
// class _PurchaseCatState extends State<PurchaseCat> {
//   UserController _userController;
//   int _indexPage;
//
// //  PaymentController _paymentController;
//   PlanController _planController;
//   PageController pageController;
//
//   // Offerings _offerings;
//   List<Package> _packages = [];
//   bool _loading;
//
//   @override
//   void initState() {
//     _loading = true;
//     _userController = Provider.of<UserController>(context, listen: false);
//     _planController = Provider.of<PlanController>(context, listen: false);
//     _indexPage = 1;
//     pageController =
//         PageController(viewportFraction: 0.8, initialPage: _indexPage);
//     //_paymentController = Provider.of<PaymentController>(context, listen: false);
//     // _payment = _userController.payment;
//     super.initState();
//     initPlatformState();
//   }
//
//   @override
//   Future<void> dispose() async {
//     super.dispose();
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     // String apiToken = Platform.isAndroid
//     //     ? dotenv.env['PURCHASE_GOOGLE']
//     //     : dotenv.env['PURCHASE_API'];
//     String apiToken =  dotenv.env['PURCHASE_API'];
//     print("apiToken $apiToken");
//     await _planController.getPlan();
//     await Purchases.setDebugLogsEnabled(true);
//     await Purchases.setup(
//       apiToken,
//       appUserId: _userController.user.email,
//       observerMode: true,
//       userDefaultsSuiteName: _userController.user.firstName,
//     );
//     await Purchases.setFinishTransactions(true);
//
//     await _getOffering();
//
//     if (!mounted) return;
//
//     setState(() {
//       _loading = false;
//     });
//   }
//
//   Future<void> _getOffering() async {
//     _packages = [];
//     try {
//       Offerings offerings = await Purchases.getOfferings();
//       print(offerings);
//       offerings.all.forEach((key, value) {
//         if (value.monthly != null) {
//           _packages.add(value.monthly);
//         }
//       });
//       _packages.sort((a, b) => a.product.price.compareTo(b.product.price));
//       setState(() {});
//     } on PlatformException catch (e) {
//       print(e);
//     }
//     if (!mounted) return;
//   }
//
//   _buyProduct() async {
//     try {
//       Package package = _packages[_indexPage];
//       // Purchases.setPushToken(pushToken);
//       _loading = true;
//       setState(() {});
//       print("package.product ${package.product}");
//
//       String identifier = package.product.identifier;
//
//       String title = _getTitle(identifier);
//
//       await Purchases.setAttributes({
//         "email": _userController.user.email,
//       });
//
//       await Purchases.setEmail(_userController.user.email);
//       await Purchases.setDisplayName(
//         "${_userController.user.firstName} ${_userController.user.lastName}",
//       );
//       if (_userController.user.phone != null) {
//         await Purchases.setPhoneNumber(_userController.user.phone);
//       }
//       final purchasedProduct = await Purchases.purchasePackage(package);
//       _loading = false;
//       setState(() {});
//
//       print(title);
//       print(jsonEncode(purchasedProduct.entitlements.all[title]));
//       print(jsonEncode(purchasedProduct.entitlements));
//
//       bool isActive = purchasedProduct.entitlements.all[title].isActive;
//       print("isActive $isActive");
//       print(
//           "_userController.payment.plan.planIdAppStore ${_userController.payment.plan.planIdAppStore}");
//
//       if (isActive) {
//         if (_userController.payment == null ||
//             _userController.payment.plan.planIdAppStore != identifier) {
//           StateM(context).navOff(PaymentSuccess());
//           return;
//         }
//       }
//       await _userController.getUser();
//       StateM(context).navOff(Start());
//     } on PlatformException catch (e) {
//       _loading = false;
//       setState(() {});
//       final errorCode = PurchasesErrorHelper.getErrorCode(e);
//       if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
//         print('User cancelled');
//       } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
//         print('User not allowed to purchase');
//       } else if (errorCode == PurchasesErrorCode.paymentPendingError) {
//         print('Payment is pending');
//       }
//     }
//   }
//
//   String _getTitle(String identifier) {
//     Plan _plan = _planController.plans
//         .firstWhere((element) => element.planIdAppStore == identifier);
//     return _plan.title;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return NetworkConnection(_packages.length == 0 && !_loading
//         ? Scaffold(
//             body: Container(
//               width: StateM(context).width(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "No Packages found!",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(
//                     height: reSize(context, 20),
//                   ),
//                   ButtonPrimaryOutline(
//                     callback: () => StateM(context).navBack(),
//                     text: 'Go Back',
//                     width: 264,
//                   )
//                 ],
//               ),
//             ),
//           )
//         : LoadingPage(
//             _loading,
//             Container(
//               height: StateM(context).height(),
//               width: StateM(context).width(),
//               child: Column(
//                 children: [
//                   TitlePage(
//                     title: "Subscription Plan",
//                     description: "Select plan for your business needs",
//                     needNav: true,
//                   ),
//                   SizedBox(height: StateM(context).height() > 700 ? 30 : 10),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(4),
//                         border: Border.all(
//                           width: 1,
//                           color: Color(0xFF000000).withOpacity(0.14),
//                         ),
//                       ),
//                       child: Container(
//                         child: Padding(
//                           padding: EdgeInsets.all(1),
//                           child: Row(
//                             children: [
//                               ..._packages.asMap().entries.map((package) {
//                                 int index = package.key;
//                                 return Expanded(
//                                   child: InkWell(
//                                     onTap: () {
//                                       pageController.animateToPage(
//                                         index,
//                                         duration: const Duration(seconds: 1),
//                                         curve: Curves.easeInOut,
//                                       );
//                                       _indexPage = index;
//                                       setState(() {});
//                                     },
//                                     child: Container(
//                                       height: reSize(context, 30),
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(2),
//                                           color: _indexPage == index
//                                               ? Color(0xFFFFC600)
//                                               : Colors.transparent),
//                                       child: Center(
//                                         child: Text(
//                                           _getTitle(
//                                               package.value.product.identifier),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: StateM(context).height() > 700 ? 70 : 30),
//                   Expanded(
//                     child: PageView(
//                       controller: pageController,
//                       clipBehavior: Clip.none,
//                       onPageChanged: (int page) {
//                         _indexPage = page;
//                         setState(() {});
//                       },
//                       children: <Widget>[
//                         ..._packages.asMap().entries.map((package) {
//                           int index = package.key;
//                           return PlanBlock(
//                             indexPage: _indexPage,
//                             indexBlock: index,
//                             product: _packages[index].product,
//                             plan: _planController.plans.length > 0
//                                 ? _planController.plans.firstWhere((element) =>
//                                     element.planIdAppStore ==
//                                     _packages[index].product.identifier)
//                                 : null,
//                           );
//                           // return Container(
//                           //   child: Padding(
//                           //     padding: const EdgeInsets.symmetric(horizontal: 20),
//                           //     child: Column(
//                           //       children: [
//                           //         Text(product.value.title),
//                           //         Text(product.value.description),
//                           //         Text(product.value.priceString),
//                           //         SizedBox(
//                           //           height: 10,
//                           //         ),
//                           //         TextButton(
//                           //             //  onPressed: () => _buyProduct(product),
//                           //             onPressed: _userController.payment != null &&
//                           //                     _userController
//                           //                             .payment.plan.planIdAppStore ==
//                           //                         product.value.identifier
//                           //                 ? null
//                           //                 : () => _buyProduct(product.value),
//                           //             child: Text("Buy")),
//                           //         Container(
//                           //           color: Color(0xFFCCCCCC),
//                           //           height: 1,
//                           //         ),
//                           //         SizedBox(
//                           //           height: 10,
//                           //         ),
//                           //       ],
//                           //     ),
//                           //   ),
//                           // );
//                         }),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: StateM(context).height() > 700 ? 70 : 30),
//                   RichText(
//                     text: TextSpan(
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.secondary,
//                         fontSize: 14,
//                       ),
//                       children: [
//                         TextSpan(
//                             text: '*\$25 for each additional notarization'),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: ButtonPrimary(
//                       text: 'Subscribe',
//                       // callback: _products.length == 0 ||
//                       //         _userController.payment != null &&
//                       //             _userController.payment.plan.planIdAppStore ==
//                       //                 _products[_indexPage].identifier
//                       //     ? null
//                       //     : () => _buyProduct(_products[_indexPage]),
//                       callback: () => _buyProduct(),
//                     ),
//                   ),
//                   SizedBox(
//                       height: StateM(context).height() < 670
//                           ? 20
//                           : reSize(context, 40)),
//                 ],
//               ),
//             )));
//   }
// }
