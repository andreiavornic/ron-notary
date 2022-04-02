import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/title_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

const List<String> _productIds = <String>[
  'basic.ronary.com',
  'business.ronary.com',
  'pro.ronary.com'
];

class PurchaseApp extends StatefulWidget {
  const PurchaseApp({Key key}) : super(key: key);

  @override
  _PurchaseAppState createState() => _PurchaseAppState();
}

class _PurchaseAppState extends State<PurchaseApp> {
  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _connectionSubscription;
  FlutterInappPurchase _appPurchase = FlutterInappPurchase.instance;

  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];
  UserController _userController;
  bool _loading;

  @override
  void initState() {
    _loading = true;
    _userController = Provider.of<UserController>(context, listen: false);
    _initPlatformState();
    super.initState();
  }

  Future<void> _initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await _appPurchase.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    var result = await _appPurchase.initialize();
    print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // refresh items for android
    // try {
    //   String msg = await _appPurchase.consumeAll();
    //   print('consumeAllItems: $msg');
    // } catch (err) {
    //   print('consumeAllItems error: $err');
    // }

    _connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      print('purchase-updated: $productItem');

      if (Platform.isAndroid) {
        print(productItem.purchaseToken);
        var acknowledge = await _appPurchase
            .acknowledgePurchaseAndroid(productItem.purchaseToken);
        print("acknowledge $acknowledge");
        // http.Response valid = await _appPurchase.validateReceiptAndroid(
        //   packageName: transactionReceipt['packageName'],
        //   productId: transactionReceipt['productId'],
        //   productToken: transactionReceipt['purchaseToken'],
        //   accessToken: transactionReceipt['purchaseToken'],
        //   isSubscription: true,
        // );

        setState(() {});
      } else {
        var result =
            await _appPurchase.finishTransactionIOS(productItem.purchaseToken);
        print("result finishTransactionIOS $result");
      }
      if (_purchases.isEmpty) {
        _purchases.add(productItem);
      } else {
        _purchases[0] = productItem;
      }
      print(productItem);
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
    });
    await _getProduct();
    await _getPurchases();
  }

  Future _getProduct() async {
    print("_getProduct() => Executed!");
    List<IAPItem> items = Platform.isAndroid
        ? await _appPurchase.getSubscriptions(_productIds)
        : await _appPurchase.getProducts(_productIds);
    for (var item in items) {
      // print('${item.toString()}');
      this._items.add(item);
    }

    setState(() {
      this._items = items;
      _loading = false;
    });
  }

  Future _getPurchases() async {
    List<PurchasedItem> items = await _appPurchase.getAvailablePurchases();
    for (var item in items) {
      print('${item.transactionDate}');
      print('${item.productId}');
      this._purchases.add(item);
    }

    setState(() {
      this._purchases = items;
    });
  }

  void _requestPurchase(IAPItem item) async {
    try {
      PurchasedItem _oldPurchase;
      if (_purchases.length > 0) {
        _oldPurchase = _purchases.last;
      }
      if (_oldPurchase != null) {
        await _appPurchase.requestSubscription(
          item.productId,
          oldSkuAndroid: _oldPurchase.transactionId,
          prorationModeAndroid: 4,
          obfuscatedAccountIdAndroid: _userController.user.id,
          obfuscatedProfileIdAndroid: _userController.user.email,
          purchaseTokenAndroid: _oldPurchase.purchaseToken,
        );
      } else {
        await _appPurchase.requestSubscription(
          item.productId,
        );
      }
    } catch (err) {
      showError(err, context);
    }
  }

  _getPurchaseHistory() async {
    print("_getPurchaseHistory() => Excuted!");
    try {
      List<PurchasedItem> _purchasedItems =
          await _appPurchase.getPurchaseHistory();
      print(_purchasedItems.length);
      _purchasedItems.forEach((element) {
        print(element.productId);
        print(element.transactionDate);
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  void dispose() async {
    super.dispose();
    if (_connectionSubscription != null) {
      _connectionSubscription.cancel();
      _connectionSubscription = null;
    }
    if (_purchaseUpdatedSubscription != null) {
      _purchaseUpdatedSubscription.cancel();
      _purchaseUpdatedSubscription = null;
    }
    if (_purchaseErrorSubscription != null) {
      _purchaseErrorSubscription.cancel();
      _purchaseErrorSubscription = null;
    }
    await _appPurchase.finalize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingPage(
          _loading,
          Container(
            width: StateM(context).width(),
            height: StateM(context).height(),
            child: Column(
              children: [
                TitlePage(
                  title: "Billing",
                  description: "Billing",
                  needNav: true,
                ),
                ..._items.map((item) => InkWell(
                      onTap: () => _requestPurchase(item),
                      child: Container(
                        height: 40,
                        child: Text(item.title),
                      ),
                    )),
                Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_purchases.length > 0)
                            ..._purchases.map((item) => Column(
                                  children: [
                                    Text(item.productId),
                                    Text("${item.transactionDate}"),
                                    Text("${item.transactionId}"),
                                  ],
                                )),
                        ],
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}
