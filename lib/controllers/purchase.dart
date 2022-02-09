import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';
import 'package:notary/methods/show_error.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import 'package:dio/dio.dart' as dio;
import 'package:notary/services/dio_service.dart';
import 'package:notary/widgets/payment_success.dart';

class PurchaseController extends GetxController {
  StreamSubscription<ConnectionResult> _connectionSubscription;
  StreamSubscription<PurchasedItem> _purchaseUpdatedSubscription;
  StreamSubscription<PurchaseResult> _purchaseErrorSubscription;
  final FlutterInappPurchase _flutterPurchase = FlutterInappPurchase.instance;
  RxBool _pending = RxBool(false);

  final List<String> _productIds = Platform.isAndroid
      ? ['basic.ronary.com', 'business.ronary.com', 'pro.ronary.com']
      : ['basic.ronary.com', 'business.ronary.com', 'pro.ronary.com'];

  RxList<IAPItem> _products = RxList<IAPItem>([]);
  RxList<PurchasedItem> _purchaseHistory = RxList<PurchasedItem>([]);

  // PurchasedItem _pastPurchased;

  RxList<IAPItem> get products => _products;

  List<PurchasedItem> get purchaseHistory => _purchaseHistory;

  RxBool get pending => _pending;

  @override
  void onInit() {
    print("PurchaseController => init()");
    _initConnection();
    super.onInit();
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    _purchaseErrorSubscription.cancel();
    _purchaseUpdatedSubscription.cancel();
    _flutterPurchase.finalize();
    super.dispose();
  }

  Future<void> _initConnection() async {
    await _flutterPurchase.initialize();
    _connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print("connected $connected");
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen(_handlePurchaseUpdate);

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen(_handlePurchaseError);

    _getItems();
  }

  Future<void> _getItems() async {
    List<IAPItem> items = await _flutterPurchase.getSubscriptions(_productIds);
    for (var item in items) {
      _products.add(item);
    }
    update();
  }

  void getPastPurchase() async {
    _purchaseHistory.value = await _flutterPurchase.getPurchaseHistory();
    update();
    // Verify past purchase
  }

  void _handlePurchaseUpdate(PurchasedItem productItem) async {
    if (Platform.isAndroid) {
      await _handlePurchaseUpdateAndroid(productItem);
    } else {
      await _handlePurchaseUpdateIOS(productItem);
    }
  }

  void _handlePurchaseError(PurchaseResult purchaseError) {
    print("Purchase Error: ${purchaseError.message}");
    showError("Purchase Error: ${purchaseError.message} ${purchaseError.code}");
  }

  _handlePurchaseUpdateAndroid(PurchasedItem purchasedItem) async {}

  _handlePurchaseUpdateIOS(PurchasedItem purchasedItem) async {
    switch (purchasedItem.transactionStateIOS) {
      case TransactionState.deferred:
        // _flutterPurchase.finishTransaction(purchasedItem);
        break;
      case TransactionState.failed:
        showError("Is error");
        break;
      case TransactionState.purchased:
        print("Product purchases");
        await _verifyAndFinishTransaction(purchasedItem);
        _pending.value = false;
        update();
        break;
      case TransactionState.purchasing:
        // _pending.value = true;
        // update();
        break;
      case TransactionState.restored:
        // _flutterPurchase.finishTransaction(purchasedItem);
        break;
      default:
    }
  }

  ObserverList<Function(String)> _errorListeners =
      new ObserverList<Function(String)>();

  addToErrorListeners(Function callback) {
    _errorListeners.add(showError("Error to add!"));
  }

  removeFromErrorListeners(Function callback) {
    _errorListeners.remove(callback);
  }

  Future<Null> buyProduct(int index) async {
    _pending.value = true;
    update();
    try {
      var transactions = await SKPaymentQueueWrapper().transactions();
      await Future.wait(transactions.map((transaction) =>
          SKPaymentQueueWrapper().finishTransaction(transaction)));
      await _flutterPurchase.requestSubscription(_products[index].productId);
    } catch (error) {
      throw error;
    }
  }

  _verifyAndFinishTransaction(PurchasedItem purchasedItem) async {
    try {
      dio.Response resDio = await makeRequest(
        'payment/purchase',
        "POST",
        {
          "transactionReceipt": purchasedItem.transactionReceipt,
          "transactionId": purchasedItem.transactionId,
        },
      );
      var extracted = resDio.data;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      update();
      Get.offAll(() => PaymentSuccess(), transition: Transition.noTransition);
    } catch (err) {
      throw err;
    }
  }

  Future<void> getHistory() async {
    print("getHistory() => Executed!");
    try {
      List<PurchasedItem> purchaseHistory =
          await _flutterPurchase.getPurchaseHistory();

      purchaseHistory.forEach((element) {
        print(element.transactionStateIOS);
      });

      purchaseHistory
          .sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
      _purchaseHistory.value = purchaseHistory;
      update();
    } catch (err) {
      throw err;
    }
  }
}
